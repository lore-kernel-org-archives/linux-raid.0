From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: Suggestion needed for fixing RAID6
Date: Fri, 23 Apr 2010 10:47:47 +0200
Message-ID: <695a01cae2c1$a72907d0$0400a8c0@dcccs>
References: <626601cae203$dae35030$0400a8c0@dcccs> <20100423065143.GA17743@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "Luca Berra" <bluca@comedia.it>
To: <linux-raid@vger.kernel.org>
Sent: Friday, April 23, 2010 8:51 AM
Subject: Re: Suggestion needed for fixing RAID6


> On Thu, Apr 22, 2010 at 12:09:08PM +0200, Janos Haar wrote:
>> Hello Neil, list,
>>
>> I am trying to fix one RAID6 array wich have 12x1.5TB (samsung) drives.
>> Actually the array have 1 missing drive, and 3 wich have some bad 
>> sectors!
>> Genearlly because it is RAID6 there is no data lost, because the bad 
>> sectors are not in one address line, but i can't rebuild the missing 
>> drive, because the kernel drops out the bad sector-drives one by one 
>> during the rebuild process.
>
> I would seriously consider moving the data out of that array and dumping
> all drives from that batch, and this is gonna be painful because you
> must watch drives being dropped and add them back, and yes you need the
> resources to store the data.
>
> ddrescue won't obviously work, since it will mask read errors and turn
> those into data corruption
>
> the raid 1 trick wont work, as you noted
>
> another option could be using the device mapper snapshot-merge target
> (writable snapshot), which iirc is a 2.6.33+ feature
> look at
> http://smorgasbord.gavagai.nl/2010/03/online-merging-of-cow-volumes-with-dm-snapshot/
> for hints.
> btw i have no clue how the scsi error will travel thru the dm layer.
> L.

...or cowloop! :-)
This is a good idea! :-)
Thank you.

I have another one:
re-create the array (--assume-clean) with external bitmap, than drop the 
missing drive.
Than manually manipulate the bitmap file to re-sync only the last 10% wich 
is good enough for me...

Thanks again,
Janos

>
> -- 
> Luca Berra -- bluca@comedia.it
>          Communication Media & Services S.r.l.
>   /"\
>   \ /     ASCII RIBBON CAMPAIGN
>    X        AGAINST HTML MAIL
>   / \
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

