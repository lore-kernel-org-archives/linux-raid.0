From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Wed, 29 Oct 2008 09:56:10 +0100
Message-ID: <20081029085610.GA25243@boogie.lpds.sztaki.hu>
References: <18692.62860.863118.727187@notabene.brown> <ac3eb2510810270541g2ac57bd1p5576f15959e849e@mail.gmail.com> <18694.19834.523955.697048@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18694.19834.523955.697048@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids

On Tue, Oct 28, 2008 at 10:23:38AM +1100, Neil Brown wrote:

> I'm not entirely convinced.  However I can see a real difficulty in
> introducing a new sequence number.  Thus if a 'ddf' array gets created
> as /dev/md15, then if I want to create a name containing the string
> 'ddf', it should be 'ddf15'.  Maybe /dev/ddf15.  Maybe /dev/md/ddf15.

Or, if you want to follow the logic of /dev/disk/by-*, something like
/dev/md/by-container/ddf-md15 (or ddf-<UUID>).

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
