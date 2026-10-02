* Boundary elements REAL <-> electrical

.model a2d_real a2d mode=real
.model d2a_real d2a mode=real

.defhook a2d_real d2a_real

.probe tran v

.tran 500ps 1us