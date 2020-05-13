From: Wolfgang Denk <wd@denx.de>
Subject: Re: raid6check extremely slow ?
Date: Wed, 13 May 2020 08:18:02 +0200
Message-ID: <20200513061802.3BA97240E1A@gemini.denx.de>
References: <20200510120725.20947240E1A@gemini.denx.de> <2cf55e5f-bdfb-9fef-6255-151e049ac0a1@cloud.ionos.com> <20200511064022.591C5240E1A@gemini.denx.de> <f003a8c7-e96d-ddc3-6d1d-42a13b70e0b6@cloud.ionos.com> <20200511161415.GA8049@lazy.lzy> <23d84744-9e3c-adc1-3af1-6498b9bcf750@cloud.ionos.com> <20200512160712.GB7261@lazy.lzy> <e24b0703-a599-45ef-f6b6-0a713cfa414c@cloud.ionos.com> <20200512183251.GA11548@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20200512183251.GA11548@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Piergiorgio,

In message <20200512183251.GA11548@lazy.lzy> you wrote:
>
> > > > xmalloc.o dlink.o
> > > > sysfs.o: In function `sysfsline':
> > > > sysfs.c:(.text+0x2adb): undefined reference to `parse_uuid'
> > > > sysfs.c:(.text+0x2aee): undefined reference to `uuid_zero'
> > > > sysfs.c:(.text+0x2af5): undefined reference to `uuid_zero'
> > > > collect2: error: ld returned 1 exit status
> > > > Makefile:220: recipe for target 'raid6check' failed
> > > > make: *** [raid6check] Error 1
> > > I cannot see this problem.
> > > I could compile without issue.
> > > Maybe some library is missing somewhere,
> > > but I'm not sure where.
> > 
> > Do you try with the fastest mdadm tree? But could be environment issue ...
>
> I'm using Fedora, so I downloaded
> the .srpm package, installed, enabled
> raid6check, patched and rebuild...

Fedora 32 is still at mdadm-4.1 (Mon Oct 1 14:27:52 2018), but it
seems the significant change was introduced bu commit b06815989
"mdadm: load default sysfs attributes after assemblation" (Wed Jul 10
13:38:53 2019).

If you try to build top of tree you should see the problem, too
[and the -Werror issue I mentioned before, which is also fixed
in Fedora by local distro patches.]

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
As far as the laws of mathematics refer to reality, they are not cer-
tain, and as far as they are certain, they do not refer  to  reality.
                                                   -- Albert Einstein
