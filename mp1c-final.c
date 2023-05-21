#include <stdio.h>
#include <stdlib.h>

#define GRID_COLS 7
#define GRID_ROWS 10
#define PIECE_COLS 5

char* final_grid;

void copy(char* src, char* dst, int n);
char is_equal_grids(char gridOne[70], char gridTwo[70]);
void print_grid(char grid[70]);
char* freeze_blocks(char grid[70]);
int get_max_x_of_piece(char piece[8]);
char* drop_piece_in_grid(char grid[70], char piece[8], int yOffset, char* isSuccess);
void convert_piece_to_pairs(char pieceGrid[20], char pieceCoords[8]);
char backtrack(char currGrid[70], char* chosen, char* pieces, int numPieces);

int main() {
    // You should define the following variables in the .text(?) segment ng
    // MIPS.

    // Each row will be 6 characters (either '.' or '#') followed by a
    // null character '\0' (to make reading and printing strings easier)
    char* start_grid = malloc(71);
    final_grid = malloc(71);
    char pieceAscii[21];

    // Fill up the first four rows with dots
    
    // temp = row * GRID_COLS
    for(int temp = 0, row = 0; row < 4; row++, temp += GRID_COLS) {
        for(int col = 0; col < 6; col++) {
            start_grid[temp + col] = '.';
            final_grid[temp + col] = '.';
        }
        start_grid[temp + 6] = '\n';
        final_grid[temp + 6] = '\n';
    }

    // Read 6 character inputs for the next 6 rows
    for(int row = 4; row < 10; row++) {
        // This should be equivalent to calling syscall in mips with
        //   $v0 = 8 (read string)
        //   $a0 = start_grid + (GRID_COLS * row)
        //   $a1 = 7

        // Read a line
        fgets(start_grid + (GRID_COLS * row), GRID_COLS + 1, stdin);
    }

    // do the same for final_grid
    for(int row = 4; row < 10; row++) {
        fgets(final_grid + (GRID_COLS * row), GRID_COLS + 1, stdin);
    }


    for(int row = 4, temp = GRID_COLS * 4; row < 10; row++, temp += GRID_COLS) {
        for(int col = 0; col < 6; col++) {
            if(start_grid[temp + col] == '#') {
                start_grid[temp + col] = 'X';  
            }
            if(final_grid[temp + col] == '#') {
                final_grid[temp + col] = 'X';
            }
        }
    }

    int numPieces;
    scanf("%d", &numPieces);
    fgetc(stdin);

    // Use the sbrk syscall ($v0 = 9, $a0 = number of bytes) to allocate
    // memory instead of malloc
    // Note that chosen is an array of bools, but bools are just chars,
    // with 0 = FALSE, 1 = TRUE
    char *chosen = malloc(numPieces);

    // converted_pieces will be storing the coordinates of each '#' tile
    // in each piece. We can represent each piece as
    //      {piece1_tile1_X, piece1_tile1_Y, piece1_tile2_X, ..., piece4_tile4_Y}
    // with X and Y taking up one byte each, for a total of 8 bytes per piece.
    // Thus, the size of converted_pieces will be (8 * numPieces) bytes big.
    char *converted_pieces = malloc(8 * numPieces);
    for(int i = 0; i < numPieces; i++) {
        for(int row = 0; row < 4; row++) {
            fgets(pieceAscii + (PIECE_COLS * row), PIECE_COLS + 1, stdin);
        }
        convert_piece_to_pairs(pieceAscii, converted_pieces + i * 8);
    }

    char answer = backtrack(start_grid, chosen, converted_pieces, numPieces);
    if(answer == 1) {
        printf("YES\n");
    } else {
        printf("NO\n");
    }

    free(start_grid);
    free(final_grid);
    free(converted_pieces);
}

void copy(char* src, char* dst, int n) {
    for(int i = 0; i < n; i++) {
        dst[i] = src[i];
    }
}

char is_equal_grids(char gridOne[70], char gridTwo[70]) {
    char result = 1;
    for(int i = 0; i < 10; i++) {
        for(int j = 0; j < 6; j++) {
            result = result && gridOne[(i*GRID_COLS) + j] == gridTwo[(i * GRID_COLS) + j];
        }
    }
    return result;
}

void print_grid(char grid[70]) {
    for(int i = 0; i < 10; i++) {
        printf(grid + i * GRID_COLS);
        putchar('\n');
    }
}

char* freeze_blocks(char grid[70]) {
    for(int i = 0; i < 10; i++) {
        for(int j = 0; j  < 6; j++) {
            if(grid[(i * GRID_COLS) + j] == '#') {
                grid[(i * GRID_COLS) + j] = 'X';
            }
        }
    }
    return grid;
}

int get_max_x_of_piece(char piece[8]) {
    int max_x = -1;
    for(int i = 1; i < 8; i += 2) {
        if(max_x < piece[i]) {
            max_x = piece[i];
        }
    }
    return max_x;
}

char* drop_piece_in_grid(char grid[70], char piece[8], int yOffset, char* isSuccess) {
    char* gridCopy = malloc(71);
    copy(grid, gridCopy, 71);
    int maxY = 100;


    // put piece in grid

    for(int i = 0; i < 8; i += 2) {
        gridCopy[ (piece[i] * GRID_COLS) + piece[i+1] + yOffset ] = '#';
    }

    // only active blocks are '#'; frozen blocks are 'X'
    while(1) {
        char canStillGoDown = 1;
        for(int i = 0; i < 10; i++) {
            for(int j = 0; j < 6; j++) {
                if(gridCopy[ (i * GRID_COLS) + j ] == '#' &&
                   (i == 9 || gridCopy[ ((i + 1) * GRID_COLS) + j] == 'X')) {
                    canStillGoDown = 0;
                }
            }
        }

        if(canStillGoDown) {
            for(int i = 8; i > -1; i--) {
                for(int j = 0; j < 6; j++) {
                    if(gridCopy[ (i * GRID_COLS) + j ] == '#') {
                        gridCopy[ ((i + 1) * GRID_COLS) + j ] = '#';
                        gridCopy[ (i * GRID_COLS) + j ] = '.';
                    }
                }
            }
        } else {
            break;
        }
    }

    for(int i = 0; i < 10; i++) {
        for(int j = 0; j < 6; j++) {
            if(gridCopy[  (i * GRID_COLS) + j ] == '#') {
                if(i < maxY) {
                    maxY = i;
                }
            }
        }
    }

    if(maxY <= 3) {
        *isSuccess = 0;
        return grid;
    } else {
        *isSuccess = 1;
        return freeze_blocks(gridCopy);
    }
}

void convert_piece_to_pairs(char pieceGrid[20], char pieceCoords[8]) {
    int k = 0;
    for(int i = 0; i < 4; i++) {
        for(int j = 0; j < 4; j++) {
            if(pieceGrid[ (i * PIECE_COLS) + j ] == '#') {
                pieceCoords[k] = i;
                pieceCoords[k + 1] = j;
                k += 2;
            }
        }
    }
}

char backtrack(char currGrid[70], char* chosen, char* pieces, int numPieces) {
    char success;

    if(is_equal_grids(currGrid, final_grid)) {
        return 1;
    }
    for(int i = 0; i < numPieces; i++) {
        if(chosen[i] == 1) {
            continue;
        }

        int max_offset = 6 - get_max_x_of_piece(pieces + i * 8);
        char* chosenCopy = malloc(numPieces * 8);
        copy(chosen, chosenCopy, numPieces * 8);
        for(int offset = 0; offset < max_offset; offset++) {
            char* nextGrid = drop_piece_in_grid(currGrid, pieces + 8 * i, offset, &success);
            if(success == 1) {
                chosenCopy[i] = 1;
                if(backtrack(nextGrid, chosenCopy, pieces, numPieces) == 1) {
                    return 1;
                }
            }
        }
    }
    return 0;
}