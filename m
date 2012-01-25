From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 2/4] Add --initrd argument to mdadm
Date: Wed, 25 Jan 2012 11:53:53 +0100
Message-ID: <4F1FDF41.6000909@redhat.com>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>		<1326797330-4488-3-git-send-email-Jes.Sorensen@redhat.com>	 <20120122221758.412b18d4@notabene.brown> <4F1D358C.9070508@redhat.com>	 <4F1DBF6F.40209@redhat.com> <1327351849.6323.9.camel@mop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1327351849.6323.9.camel@mop>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Kay Sievers <kay@redhat.com>, Lennart Poettering <lpoetter@redhat.com>, linux-raid@vger.kernel.org, dledford@redhat.com, harald@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

On 01/23/12 21:50, Kay Sievers wrote:
> On Mon, 2012-01-23 at 21:13 +0100, Lennart Poettering wrote:
>> On 23.01.2012 11:25, Jes Sorensen wrote:
>>> I was trying to come up with a better name, and I think --preboot is the
>>> best I have seen so far. Other ideas I had were:
>>>   --systemd-root
>>>   --no-shutdown
>>> however I like --preboot better, so I will go with that, unless someone
>>> starts throwing things at me.
>>
>> I figure it's a bit of bike-shedding, but I'd like to ask you to stick 
>> to --initramfs or so if possible, simply because we're interested to 
>> reuse the same name for that switch for all storage daemons which need 
>> this, and the spec currently suggests --initramfs, and I'd prefer to 
>> avoid notifying all users of that change if we change it...
> 
> Last time you and I decided to rename it to --initrd, so the document
> does not say --initramfs.
> 
> Back to square one. :)

Neil,

In the light of the discussion so far, do you have any preference for
--preboot/--preroot/--initrd/--offroot

Cheers,
Jes
