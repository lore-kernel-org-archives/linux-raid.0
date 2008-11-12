From: "Billy Crook" <billycrook@gmail.com>
Subject: Re: OT: Tips for good hard drives for a home server
Date: Wed, 12 Nov 2008 12:36:02 -0600
Message-ID: <a43edf1b0811121036t7198be59r50b061c90f8798eb@mail.gmail.com>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B299C974A5A@SE-EX008.groupinfra.com>
	 <7d86ddb90811120619vca13676tb0192676ece0cb93@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb90811120619vca13676tb0192676ece0cb93@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Someone just shared this with me and I thought this might be relevant:
http://techreport.com/discussions.x/15863

If it's a home server, a little hassle might not be the end of the
world.  Personally I always try to buy the largest available drives
for mass storage, so I can go longer between upgrades, move my data
around less, and have fewer oldies sitting around.  I also wanted the
5yr warranty.  So that's lately meant Seagate.  If it needs to be no
fuss, make sure your seller will take them back for a refund if they
lock up like this.

On Wed, Nov 12, 2008 at 08:19, Ryan Wagoner <rswagoner@gmail.com> wrote:
> I used to buy Seagate drives for their 5 year warranty. However with
> the capacities increasing like they are the 5 vs 3 years doesn't
> really matter as much. Out of the 4 Seagate drives (2 160GB and 2
> 320GB) in my server that are 2.5 years old, the one is already showing
> 13 reallocated sectors. This might be due to non Barracuda drives
> being certified for only 8 hours a day.
>
> Recently I added have 5 Hitachi Deskstar TB drives in two different
> machines which have been working great with mdadm in RAID 1 and 5. I
> actually bought these after using 6 Hitachi Ultrastar TB drives in my
> work's new Dell 2950 server. The server is setup in a 2 drive RAID 1
> and a 4 drive RAID 5 for data archival and has worked flawlessly.
>
> The Hitachi's are in the same price range as the Seagate Barracuda's
> and offer 24/7 runtime and a 1 in 10^15 error rate vs 10^14 for
> Seagate.
>
> Any reason you are using RAID 0 for your server? Normally when I think
> of a server reliability comes to mind and RAID 0 doesn't offer any.
> I'm assumming you make nightly or weekly backups?
>
> Ryan
>
> On Wed, Nov 12, 2008 at 8:12 AM, Henry, Andrew <andrew.henry@logica.com> wrote:
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
