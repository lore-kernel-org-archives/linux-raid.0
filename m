From: Gioh Kim <gi-oh.kim@profitbricks.com>
Subject: Re: [PATCH 2/2] mdadm.c: fix compile error "switch condition has
 boolean value"
Date: Wed, 29 Mar 2017 17:50:26 +0200
Message-ID: <20170329155025.GC17378@ws00837>
References: <1490780434-8720-1-git-send-email-gi-oh.kim@profitbricks.com>
 <1490780434-8720-2-git-send-email-gi-oh.kim@profitbricks.com>
 <wrfjpoh0dqzz.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <wrfjpoh0dqzz.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 29, 2017 at 11:47:28AM -0400, jes.sorensen@gmail.com wrote:
> Gioh Kim <gi-oh.kim@profitbricks.com> writes:
> > Remove a boolean expression in switch condition
> > to prevent compile error of some compilers.
> 
> Please be specific, which compile is unable to handle this?
> 
> > Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
> > ---
> >  mdadm.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/mdadm.c b/mdadm.c
> > index 08ddcab..a98a051 100644
> > --- a/mdadm.c
> > +++ b/mdadm.c
> > @@ -1905,11 +1905,11 @@ static int misc_list(struct mddev_dev *devlist,
> >  			rv |= SetAction(dv->devname, c->action);
> >  			continue;
> >  		}
> > -		switch(dv->devname[0] == '/') {
> > -			case 0:
> > +		switch(dv->devname[0]) {
> > +			default:
> >  				mdfd = open_dev(dv->devname);
> >  				if (mdfd >= 0) break;
> > -			case 1:
> > +			case '/':
> >  				mdfd = open_mddev(dv->devname, 1);  
> >  		}
> >  		if (mdfd>=0) {
> 
> While I agree the original code is ugly, I am not convinced your
> replacement is a lot prettier.
> 

Yes, it's not elegant ;-)
Following is my compiler version and error message.

gohkim@ws00837:~$ gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/5/lto-wrapper
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Ubuntu
5.2.1-22ubuntu2' --with-bugurl=file:///usr/share/doc/gcc-5/README.Bugs
--enable-languages=c,ada,c++,java,go,d,fortran,objc,obj-c++ --prefix=/usr
--program-suffix=-5 --enable-shared --enable-linker-build-id
--libexecdir=/usr/lib --without-included-gettext --enable-threads=posix
--libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu
--enable-libstdcxx-debug --enable-libstdcxx-time=yes
--with-default-libstdcxx-abi=new --enable-gnu-unique-object
--disable-vtable-verify --enable-libmpx --enable-plugin --with-system-zlib
--disable-browser-plugin --enable-java-awt=gtk --enable-gtk-cairo
--with-java-home=/usr/lib/jvm/java-1.5.0-gcj-5-amd64/jre --enable-java-home
--with-jvm-root-dir=/usr/lib/jvm/java-1.5.0-gcj-5-amd64
--with-jvm-jar-dir=/usr/lib/jvm-exports/java-1.5.0-gcj-5-amd64
--with-arch-directory=amd64 --with-ecj-jar=/usr/share/java/eclipse-ecj.jar
--enable-objc-gc --enable-multiarch --disable-werror --with-arch-32=i686
--with-abi=m64 --with-multilib-list=m32,m64,mx32 --enable-multilib
--with-tune=generic --enable-checking=release --build=x86_64-linux-gnu
--host=x86_64-linux-gnu --target=x86_64-linux-gnu
Thread model: posix
gcc version 5.2.1 20151010 (Ubuntu 5.2.1-22ubuntu2) 

gohkim@ws00837:~/work/tools/mdadm-mainstream$ make
cc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -ggdb
-DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\"
-DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\"
-DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\"
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM
-DVERSION=\"4.0-25-gddb13a5\" -DVERS_DATE="\"2017-03-29\"" -DUSE_PTHREADS
-DBINDIR=\"/sbin\"  -c -o mdadm.o mdadm.c
mdadm.c: In function ��misc_list��:
mdadm.c:1908:10: error: switch condition has boolean value
[-Werror=switch-bool]
   switch(dv->devname[0] == '/') {
             ^
             cc1: all warnings being treated as errors
             <builtin>: recipe for target 'mdadm.o' failed
             make: *** [mdadm.o] Error 1


-- 
Best regards,
Gi-Oh Kim
TEL: 0176 2697 8962
