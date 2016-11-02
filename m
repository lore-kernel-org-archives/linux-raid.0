From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Issue with growing RAID10
Date: Wed, 2 Nov 2016 20:41:53 +0000
Message-ID: <20161102204153.GA23899@cthulhu.home.robinhill.me.uk>
References: <CAANLjFrK25fUjMpif6m7y3PZ0phNa_zVLFWUVs2Yj1PtbkA_Qg@mail.gmail.com>
 <20161102181923.GA21325@www5.open-std.org>
 <CAANLjFqqTvs0Uh1R6Bvk9FyQUgQqhj+48uC4iiut_A3Uh6j6DA@mail.gmail.com>
 <20161102194842.GA25173@www5.open-std.org>
 <CAANLjFpQ-s4E3dKmaEEp0DcWaSQx21-Leafukir6idET++zMsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAANLjFpQ-s4E3dKmaEEp0DcWaSQx21-Leafukir6idET++zMsg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed Nov 02, 2016 at 01:56:02pm -0600, Robert LeBlanc wrote:

> Yes, we can have any number of disks in a RAID1 (we currently have
> three), but reads only ever come from the first drive.
> 
How are you testing? I use RAID1 on a number of systems and reads
look to be pretty evenly spread across the drives.

Cheers,
    Robin
