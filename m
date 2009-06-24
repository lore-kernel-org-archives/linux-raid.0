From: "NeilBrown" <neilb@suse.de>
Subject: RE: RAID-5 creation crashes when files system installed while      
     recovery going on
Date: Wed, 24 Jun 2009 16:55:43 +1000 (EST)
Message-ID: <a765142d3b99baf3edb3da397b2ee350.squirrel@neil.brown.name>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C0797AC80@SDCEXCHANGE01.ad.amcc.com>
    <a5f578de750a09c145f5d4f50e90a4f8.squirrel@neil.brown.name>
    <AC5E1C3367E37D44970B81A6ADD1DA2C0534ABE5@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C0534ABE5@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Wed, June 24, 2009 4:39 pm, Tirumala Reddy Marri wrote:
> My meaning of crash was kernel panic happens.  BTW we have HW acceleration
> to do the XOR calculations which uses ADMA driver model.
> Thanks,
> MArri

Is it possible to get details of this panic?  A digital photo
of the screen perhaps?

NeilBrown

>
> ________________________________
>
> From: linux-raid-owner@vger.kernel.org on behalf of NeilBrown
> Sent: Tue 6/23/2009 7:31 PM
> To: Tirumala Reddy Marri
> Cc: linux-raid@vger.kernel.org
> Subject: Re: RAID-5 creation crashes when files system installed while
> recovery going on
>
>
>
> On Wed, June 24, 2009 8:35 am, Tirumala Reddy Marri wrote:
>> All,
>>  I started RAID-5 creation using mdadm command. While recovery is
>> happening I tried to install file system . I see intermittent crash   .
>> And crash doesn't happen at fixed location. Any clue what could be the
>> problem? How does the read/writes to MD driver handled while RAID-5 is
>> under building.
>
> Can you describe exactly what you mean by "crash" ??
>
> The raid5 driver normally has no problems handling writes while
> it is resyncing.  It has a 'stripe_cache' which is used to
> synchronise regular IO with resync IO.
>
> NeilBrown
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>

