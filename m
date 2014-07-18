From: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Subject: RE: [REGRESSION] mdadm git fails to compile with "make mdassemble"
 after 0c21b485e4beb7bcfe631412a231f7c1ea1067bc
Date: Fri, 18 Jul 2014 15:12:19 +0000
Message-ID: <84A53BEA6EAC69439B7E311E9B17A76F19CC3CBC@IRSMSX105.ger.corp.intel.com>
References: <53C92A9D.3070009@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53C92A9D.3070009@gentoo.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Samuli Suominen <ssuominen@gentoo.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

> On Friday, July 18, 2014 4:10 PM Samuli Suominen [ssuominen@gentoo.org] wrote:
> To: linux-raid@vger.kernel.org; NeilBrown
> Subject: [REGRESSION] mdadm git fails to compile with "make mdassemble"
> after 0c21b485e4beb7bcfe631412a231f7c1ea1067bc
> 
> The broken commit is,
> http://git.neil.brown.name/?p=mdadm.git;a=commit;h=0c21b485e4beb7bcf
> e631412a231f7c1ea1067bc
> 
> $ make mdassemble
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -
> ggdb -DSendmail=\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=\"/etc/mdadm.conf\" -
> DCONFFILE2=\"/etc/mdadm/mdadm.conf\"
> -DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -
> DMDMON_DIR=\"/run/mdadm\"
> -DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\"
> -DVERSION=\"3.3.1-14-g13ffbe8\" -DVERS_DATE="\"17th July 2014\""
> -DUSE_PTHREADS -DBINDIR=\"/sbin\" -Wall -Werror -Wstrict-prototypes -
> Wextra -Wno-unused-parameter -ggdb -DSendmail=\""/usr/sbin/sendmail -
> t"\" -DCONFFILE=\"/etc/mdadm.conf\"
> -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\"
> -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\"
> -DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\"
> -DVERSION=\"3.3.1-14-g13ffbe8\" -DVERS_DATE="\"17th July 2014\""
> -DUSE_PTHREADS -DMDASSEMBLE -o mdassemble mdassemble.c
> Assemble.c Manage.c config.c policy.c dlink.c util.c maps.c lib.c xmalloc.c
> super0.c super1.c super-ddf.c super-intel.c sha1.c crc32.c sg_io.c mdstat.c
> platform-intel.c probe_roms.c sysfs.c super-mbr.c super-gpt.c pwgr.c
> super-intel.c:10611:24: error: 'validate_container_imsm' undeclared here
> (not in a function) .validate_container = validate_container_imsm, ^
> Makefile:209: recipe for target 'mdassemble' failed
> make: *** [mdassemble] Error 1
> 
> - Samuli

Hi Samuli
Thanks for raising this issue. 
Patch fixing this bug is waiting for Neil's approval.
Please see: http://marc.info/?l=linux-raid&m=140569574121989&w=2

Thanks
Pawel Baldysiak
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
