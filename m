From: NeilBrown <neilb@suse.de>
Subject: Re: Mdadm, udev and fakeraid?
Date: Tue, 5 Apr 2011 16:20:08 +1000
Message-ID: <20110405162008.5f2c48fe@notabene.brown>
References: <BANLkTinp3376PV3sJWARXtFnRfoMsg44wA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinp3376PV3sJWARXtFnRfoMsg44wA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Seblu <seblu@seblu.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 3 Apr 2011 18:03:50 +0200 Seblu <seblu@seblu.net> wrote:

> Hello,
> 
> In the following commit, udev rules load isw_raid (fakeraid). From my
> test, this doesnt work. I have to call dmraid to have something
> working.
> http://neil.brown.name/git?p=mdadm;a=commit;h=475a01b8bce8575dd1b2ab6495e65e854702ac0e
> 
> isw_raid is only fakeraid devices? mdadm is able to mount fakeraid partition?
> 

I'm sorry but I cannot parse those questions successfully so I'm not sure
what you are asking.


Both dmraid and mdadm can manage some 'fakeraid' arrays.  dmraid supports a
wider variety.  mdadm supports raid1 and raid5 more completely than dmraid
does.

Both should support isw to some degree.
Intel are currently working with mdadm to make it provide full support for
"IMSM" (Intel Matrix Storage Manager).  I don't know the exact relationship
between 'isw' and 'IMSM' - maybe they are different names for the same thing.

If mdadm doesn't work for your isw arrays, and you want it to, then I suggest
you report details about what is, or is not, happening.

Useful information would include:

 mdadm --examine /dev/DEVICE
for each device in the array.
Also the output of

 mdadm --incremental --verbose /dev/DEVICE
for each device in turn.  This should incrementally assemble the array from
all those components.

NeilBrown

