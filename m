From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 2/4] Add --initrd argument to mdadm
Date: Mon, 23 Jan 2012 11:25:16 +0100
Message-ID: <4F1D358C.9070508@redhat.com>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>	<1326797330-4488-3-git-send-email-Jes.Sorensen@redhat.com> <20120122221758.412b18d4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120122221758.412b18d4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

On 01/22/12 12:17, NeilBrown wrote:
> On Tue, 17 Jan 2012 11:48:48 +0100 Jes.Sorensen@redhat.com wrote:
> 
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>  
>> +		/*
>> +		 * --initrd sets first char of argv[0] to @. This is used
>> +		 * by systemd to signal that the tast was launched from
>> +		 * initrd/initramfs and should be preserved during shutdown
>> +		 */
>> +		case InitrdOpt:
>> +			c = argv[0];
>> +			c[0] = '@';
>> +			continue;
> 
> Why not:
>                         argv[0][0] = '@';
> ??

I always get confused by multi-indexed arrays, so I open-coded it. I
will change it.

> Also I'm wondering about the choice of "initrd" as the option name.
> After all, we mostly use initramfs these days.
> 
>  --preboot ??
>  --systemd-root-storage-daemon ??
> 
> OK, the second is a joke, and the first is introducing terminology that isn't
> widely used...

I was actually thinking --attacked-by-thunderbunnies-from-space but
users might find it a bit too long.....

>  --for-root
> ??
> 
> I'm open to suggestions, but I'm not seeing --initrd as the best choice just
> yet.

I was trying to come up with a better name, and I think --preboot is the
best I have seen so far. Other ideas I had were:
 --systemd-root
 --no-shutdown
however I like --preboot better, so I will go with that, unless someone
starts throwing things at me.

Cheers,
Jes
