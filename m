From: "NeilBrown" <neilb@suse.de>
Subject: Re: writes raid-6  building
Date: Tue, 28 Jul 2009 16:48:07 +1000 (EST)
Message-ID: <ef22d815297edaa1b3c9a6507793ddcc.squirrel@neil.brown.name>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D260@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D260@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, July 28, 2009 11:09 am, Tirumala Reddy Marri wrote:
> While raid-6 is building I noticed writes are going on to all the
> drivers. Whereas in  raid-5 I see writes happening to only one drive.
> Any clue ?

Because raid5 != raid6......

For raid5, mdadm creates a degraded array and recovers to a spare.
So it only writes to the spare.
For raid6, mdadm doesn't try to be so clever (the tradeoffs are difference)
and just creates a non-clean array so all the P and Q blocks get
written.

NeilBrown


>
> ---------- iostat dump for raid-6 ---
> Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
> sda             152.76        23.81         3.74         47          7
> sdb             181.91        25.35         5.50         50         10
> sdc             161.31        24.84         3.30         49          6
> sdd             153.77        23.52         4.02         46          8
> sde             169.85        26.29         3.27         52          6
> sdf               0.00         0.00         0.00          0          0
> sdg               0.00         0.00         0.00          0          0
> sdh               0.00         0.00         0.00          0          0
> sdi               0.00         0.00         0.00          0          0
>
> Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
> sda             152.02        24.05         3.44         47          6
> sdb             168.18        26.23         4.14         51          8
> sdc             163.64        22.76         3.69         45          7
> sdd             166.67        24.37         4.04         48          8
> sde             166.16        24.78         3.57         49          7
> sdf               0.00         0.00         0.00          0          0
> sdg               0.00         0.00         0.00          0          0
> sdh               0.00         0.00         0.00          0          0
> sdi               0.00         0.00         0.00          0          0
> ---------------
> Thanks,
> Marri
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

