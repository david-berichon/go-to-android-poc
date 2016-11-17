Wrapper GO: CGOW
---
### Objectif
Définir une stratégie pour les appels entre `GO` et `C` avec [CGO](https://golang.org/cmd/cgo/)
 

### Difficultés
Gestion des **types de donnée** et des **types de mémoire**


## Mémoire
### En C
#### 2 types de mémoire
 * Allocation/Libération *par le runtime* de C sur la pile (exemple : variables locales, appels de fonctions). 
 * Allocation/libération *dynamique* sur le tas (exemple : allocations dynamiques)
 
### En GO
 * Alloué *par le runtime* GO et libérée par le *Garbage Collector* GO


## Types natifs:
### En C
 int, int*, char, char*, void*,...
### En GO
 int, *int, string, []byte,... 


## Types CGO
Destinés à représenter les types C en GO
 * C.int, *C.int, C.char, *C.char
 
 * fournis des outils d'allocation de mémoire et des types dédiés pour la manipulation des structures données C
 * L'utilisateur doit suivre des règles précise lors de la mise en oeuvre de CGO sous peine de provoquer des corruption
 
 * Mémoire C:
 * Mémoire GO: allouée par le runtime GO
# Objectifs
Localisation claire de l'interface GO <-> C/C++:
 * utilisation 
### Gestion de la mémoire

```go
// Go string to C string
// The C string is allocated in the C heap using malloc.
// It is the caller's responsibility to arrange for it to be
// freed, such as by calling C.free (be sure to include stdlib.h
// if C.free is needed).
func C.CString(string) *C.char

// Go []byte slice to C array
// The C array is allocated in the C heap using malloc.
// It is the caller's responsibility to arrange for it to be
// freed, such as by calling C.free (be sure to include stdlib.h
// if C.free is needed).
func C.CBytes([]byte) unsafe.Pointer

// C string to Go string
func C.GoString(*C.char) string

// C data with explicit length to Go string
func C.GoStringN(*C.char, C.int) string

// C data with explicit length to Go []byte
func C.GoBytes(unsafe.Pointer, C.int) []byte
```

### Problèmatique:

