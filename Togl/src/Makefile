# Include shared parts
TOPDIR = ../..
include $(TOPDIR)/Makefile.common

# Composite options
INCLUDES = -I$(SRCDIR) -I$(TOGLDIR) \
	$(TKINCLUDES) -I. $(GLINCLUDES) $(XINCLUDES)
LIBS = $(TKLIBS) $(GLLIBS) $(XLIBS)
LIBDIRS =

OCAMLINC=-I +labltk -I $(SRCDIR)

# Files
TOGLOBJS =	ml_togl$(XO)	$(TOGLDIR)/togl$(XO)

# Extra rules
.cmx.opt: $(TOPDIR)/src/lablgl.cmxa togl.cmxa
	$(OPTLINK) -o $@ $(OCAMLINC) -ccopt -L. \
	    unix.cmxa labltk.cmxa ../../lablgl.cmxa togl.cmxa $<

all: lablgltop$(XE) lablgl$(XB)

opt: togl.cmxa

libtogl.a togl.cma: togl.cmo $(TOGLOBJS) $(CONFIG)
	$(LIBRARIAN) -o togl togl.cmo $(TOGLOBJS) $(GLLIBS) $(TKLIBS) $(XLIBS)
togl.cmxa: togl.cmx $(TOGLOBJS) $(CONFIG)
	$(LIBRARIAN) -o togl togl.cmx $(TOGLOBJS) $(GLLIBS) $(TKLIBS) $(XLIBS)

$(TOGLDIR)/togl.o:
	cd $(TOGLDIR) && $(MAKE) togl.o CC="$(CAMLC) -verbose" CFLAGS='-c -ccopt "$(COPTS) $(INCLUDES) $(TK_FLAGS)"'

$(TOGLDIR)/togl.obj:
	cd $(TOGLDIR) && \
        $(CAMLC) -verbose -c -ccopt "-DWIN32 $(COPTS) $(INCLUDES) -I." togl.c

lablgltop$(XE): ../../src/lablgl.cma togl.cma
	ocamlmktop $(CUSTOMTOP) -I . $(OCAMLINC) -o $@ \
	  labltk.cma lablgl.cma togl.cma

lablgl: $(CONFIG) Makefile libtogl$(XA)
	$(MAKE) INSTALLDIR="$(INSTALLDIR)" real-$@

real-lablgl:
	@echo generate lablgl
	echo "#!/bin/sh" > lablgl
	echo "# toplevel with lablGL and Togl" >> lablgl
	if test -f dlltogl$(XS); then \
	    echo 'exec ocaml -I +labltk -I "$(INSTALLDIR)" lablgl.cma labltk.cma togl.cma $$*' >> lablgl; \
	 else echo 'exec "$(INSTALLDIR)/lablgltop" -I +labltk -I "$(INSTALLDIR)" $$*' >> lablgl; fi
	chmod 755 lablgl

togl_tags.c: togl_tags.var
	$(VAR2SWITCH) TOGL_ < togl_tags.var > $@

preinstall:
	cp togl.mli togl.ml libtogl$(XA) "$(INSTALLDIR)"
	cd "$(INSTALLDIR)" && $(RANLIB) libtogl$(XA)
	@if test -f dlltogl$(XS); then $(MAKE) installdll; \
	 else $(MAKE) installtop; fi
	cp lablgl$(XB) "$(BINDIR)"

install:
	@if test -f lablgltop$(XE); then $(MAKE) toglinstall; fi

toglinstall: preinstall
	cp togl.cmi togl.cma $(INSTTOP) "$(INSTALLDIR)"
	@if test -f togl.cmxa; then $(MAKE) toglinstallopt; fi

installdll:
	cp dlltogl$(XS) "$(DLLDIR)"

installtop:
	cp lablgltop$(XE) "$(INSTALLDIR)"

toglinstallopt:
	cp togl.cmxa togl$(XA) togl.cmx "$(INSTALLDIR)"
	cd "$(INSTALLDIR)" && $(RANLIB) togl$(XA)

clean:
	rm -f *.cm* *.o *.obj *.so *.lib *.a *.dll *.exe *.opt *_tags.c \
	    *_tags.h *~ lablgltop$(EX) lablgl
	rm -f $(TOGLDIR)/*.o $(TOGLDIR)/*.obj

depend:
	ocamldep  -pp camlp4o *.ml *.mli > .depend

#dependencies
ml_tk$(XO): $(TOPDIR)/src/ml_gl.h tk_tags.h tk_tags.c
ml_togl$(XO) : $(TOPDIR)/src/ml_gl.h togl_tags.h togl_tags.c
include .depend
