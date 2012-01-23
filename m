From: Lennart Poettering <lpoetter@redhat.com>
Subject: Re: [PATCH 2/4] Add --initrd argument to mdadm
Date: Mon, 23 Jan 2012 21:13:35 +0100
Message-ID: <4F1DBF6F.40209@redhat.com>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>	<1326797330-4488-3-git-send-email-Jes.Sorensen@redhat.com> <20120122221758.412b18d4@notabene.brown> <4F1D358C.9070508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F1D358C.9070508@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, dledford@redhat.com, kay@redhat.com, harald@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

Heya,

On 23.01.2012 11:25, Jes Sorensen wrote:

>> I'm open to suggestions, but I'm not seeing --initrd as the best choice just
>> yet.
>
> I was trying to come up with a better name, and I think --preboot is the
> best I have seen so far. Other ideas I had were:
>   --systemd-root
>   --no-shutdown
> however I like --preboot better, so I will go with that, unless someone
> starts throwing things at me.

I figure it's a bit of bike-shedding, but I'd like to ask you to stick 
to --initramfs or so if possible, simply because we're interested to 
reuse the same name for that switch for all storage daemons which need 
this, and the spec currently suggests --initramfs, and I'd prefer to 
avoid notifying all users of that change if we change it...

Lennart
