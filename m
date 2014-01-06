From: Mark Knecht <markknecht@gmail.com>
Subject: Re: [RFC v2 0/2] New RAID library supporting up to six parities
Date: Mon, 6 Jan 2014 10:13:09 -0800
Message-ID: <CAK2H+efOLtq6onYASnZ5DsghVMp5AN70fx_uN8Ha5Wr3RxKx3A@mail.gmail.com>
References: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrea Mazzoleni <amadvance@gmail.com>
Cc: Neil Brown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Andrea,
   As others have said it looks interesting. Thanks for the efforts.

   Question: As an end-user type who currently uses mdadm RAID6, if I
wanted to set up a dedicated machine to do some SnapRAID testing then
what's the minimum disk hardware I'd need assuming Linux is just on
it's own disk?

1) 1 drive for Linux
2) 4 (or possibly 3) drives for a SnapRAID RAID6 device?
3) 3 drives for a SnapRAID RAID5 device? (If RAID5 can even use
SnapRAID. Not sure it can)

   Are there any known issues using both mdadm and SnapRAID devices in
the same system? Again, I don't care if there are and the machine dies
a brutal death (which I doubt from your announcement) but just asking.

Cheers,
Mark

On Mon, Jan 6, 2014 at 1:31 AM, Andrea Mazzoleni <amadvance@gmail.com> wrote:
> Hi,
>
> This is a port to the Linux kernel of a RAID engine that I'm currently using
> in a hobby project called SnapRAID. This engine supports up to six parities
> levels and at the same time maintains compatibility with the existing Linux
> RAID6 one.
