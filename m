From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: raid5 failed while rebuiling - classical problem
Date: Sat, 3 Jul 2010 15:51:40 +0200
Message-ID: <20100703155140.01250825@atak.bl.pg.gda.pl>
References: <20100702163155.511919c1@atak.bl.pg.gda.pl>
	<20100702231854.105b8612@atak.bl.pg.gda.pl>
	<20100703033659.0cffc6ad@natsu>
	<20100703174727.26a8965a@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100703174727.26a8965a@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roman Mamedov said:     (by the date of Sat, 3 Jul 2010 17:47:27 +0600)

> On Sat, 3 Jul 2010 03:36:59 +0600
> Roman Mamedov <roman@rm.pp.ru> wrote:
> 
> > > Then I will have an almost exact copy of bad hda3 on hdc3. 
> > > <...> maybe I could just --add hdc3 in place of hda3 ?
> > 
> > Yes, you could, and that would be the most logical thing to do (as hda might
> > continue failing and developing more bad sectors).
> 
> To clarify: you should not literally add it using the "--add" switch (that'd
> make mdadm think it's a new device needed to be filled up via resync), but
> instead make mdadm see this device instead hda. I'd try stopping the array,
> listing only the devices you want in mdadm.conf "DEVICES" lines (and ensuring
> hda3 is not there), then just doing mdadm --assemble.

Thank you very much for your help. Following command worked, or at
least seems to work:

$ mdadm -S /dev/md1
$ mdadm -Af /dev/md1 /dev/sda3 /dev/sdb3 /dev/hdc3 /dev/sdd3

I have simply put hdc3 instead of (broken) hda3.

Then I did:

$ mdadm --add /dev/md1 /dev/sdc3

and it is rebuilding now. I can mount the filesystem, and it seems
rather intact. So I unmount it again, to let it "rebuild in peace".
When rebuild is complete I will do fsck.

Thank you for pointing out dd_rescue, I had a feeling that such a
tool  existed, but I couldn't remember what it was. So I used dd.
I hope that this time I will remember dd_rescue, that it exists :)

best regards
-- 
Janek Kozicki                               http://janek.kozicki.pl/  |
