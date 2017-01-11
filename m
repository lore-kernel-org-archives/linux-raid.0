From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: ANNOUNCE: mdadm 4.0 - A tool for managing md Soft RAID under
 Linux
Date: Wed, 11 Jan 2017 11:37:47 +0800
Message-ID: <5875A88B.6060500@suse.com>
References: <1cd97490-e650-d98b-466a-095292dc5b98@gmail.com>
 <1b17f316-f974-a119-d981-fc52d1932fe2@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1b17f316-f974-a119-d981-fc52d1932fe2@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 01/11/2017 09:47 AM, Eyal Lebedinsky wrote:
> On 10/01/17 12:11, Jes Sorensen wrote:
>> I am pleased to announce the availability of
>>    mdadm version 4.0
>>
>> It is available at the usual places:
>>    http://www.kernel.org/pub/linux/utils/raid/mdadm/
>> and via git at
>>    git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
>>    http://git.kernel.org/cgit/utils/mdadm/
>>
>> The update in major version number primarily indicates this is a
>> release by it's new maintainer. In addition it contains a large number
>> of fixes in particular for IMSM RAID and clustered RAID support.  In
>> addition this release includes support for IMSM 4k sector drives,
>> failfast and better documentation for journaled RAID.
>>
>> This is my first release of mdadm. Please thank Neil Brown for his
>> previous work as maintainer and blame me for all the bugs I caused
>> since taking over.
>>
>> Jes Sorensen, 2017-01-09
>
> Hi Jes,
>
> Not sure if this is interesting but
>
> mdadm-4.0]$ make everything
> cc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
> -ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
> -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
> -DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
> -DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC 
> -DNO_DLM   -DUSE_PTHREADS  -static -o mdadm.static mdadm.o config.o 
> policy.o mdstat.o  ReadMe.o util.o maps.o lib.o Manage.o Assemble.o 
> Build.o Create.o Detail.o Examine.o Grow.o Monitor.o dlink.o Kill.o 
> Query.o Incremental.o Dump.o mdopen.o super0.o super1.o super-ddf.o 
> super-intel.o bitmap.o super-mbr.o super-gpt.o restripe.o sysfs.o 
> sha1.o mapfile.o crc32.o sg_io.o msg.o xmalloc.o platform-intel.o 
> probe_roms.o crc32c.o pwgr.o -ldl
> /usr/bin/ld: cannot find -ldl
> /usr/bin/ld: cannot find -lc
> collect2: error: ld returned 1 exit status
> make: *** [mdadm.static] Error 1

It happened when compile mdadm.static, so please make sure the static 
glibc is installed,
actually these got disappered after I have glibc-devel-static package.

>
> And while I have the podium: there is no rule to install raid6check 
> (intended?). For my convenience I added:
>
> install-raid6check: raid6check raid6check.8
>     $(INSTALL) -D -m 644 raid6check.8 $(DESTDIR)$(MAN8DIR)/raid6check.8
>     $(INSTALL) -D $(STRIP) -m 755 raid6check 
> $(DESTDIR)$(BINDIR)/raid6check

Or maybe it was ignored in origin patch.

Thanks,
Guoqing
