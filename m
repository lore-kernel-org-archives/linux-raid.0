From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 2/4] Add --initrd argument to mdadm
Date: Wed, 25 Jan 2012 14:34:23 +0100
Message-ID: <4F2004DF.7010807@redhat.com>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>	<1326797330-4488-3-git-send-email-Jes.Sorensen@redhat.com>	<20120122221758.412b18d4@notabene.brown>	<4F1D358C.9070508@redhat.com>	<4F1DBF6F.40209@redhat.com>	<1327351849.6323.9.camel@mop>	<4F1FDF41.6000909@redhat.com> <20120125223717.156d6c64@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120125223717.156d6c64@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Kay Sievers <kay@redhat.com>, Lennart Poettering <lpoetter@redhat.com>, linux-raid@vger.kernel.org, dledford@redhat.com, harald@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

On 01/25/12 12:37, NeilBrown wrote:
>> In the light of the discussion so far, do you have any preference for
>> > --preboot/--preroot/--initrd/--offroot
>> > 
> How about
>    -@
> 
> A single-character which reflects what it actually does :-)
> 
> I don't like --initrd because it is just wrong.
> 
> I can live with the others.
> 
> I think --offroot is closest to the right meaning (it is both pre and post).
> I confess a little discomfort with the word "off" as it can mean both "not on"
> and "was on".
> 
> "Did you run mdadm off root, or off /usr ??  Neither, I ran it from initramfs
> which is off root."
> 
> But I agree with Doug that the term is sufficiently unusual that people are
> unlikely to assume anything about it, so it should be safe.
> 
> I'm tempted to suggest something completely different that starts with --no-,
> like
>   --no-session-manage
> but the word 'manage' already has a couple of meaning for mdadm.
> 
> So I'm leaning towards --offroot  though I'd go for --outside-root if it were
> a bit shorter.
> 
> Maybe we need a name for this thing that exists before root is mounted and
> remains until after root is unmounted.  If we had a name for that which
> reflected its reality, that would work for me.
>  --initial-root
> isn't too bad but probably could be better.
>  --outer-root
> ??
> 
> 
> Yes, I know - you wanted a decision and I've just created more options !!
> 
>  --offroot

Ok I am going to make an executive decision here and name it --offroot.
I just want to get this settled and move on, so whoever wants to argue
about the name, too late, go back and pound your sandbag instead :)

I was tempted to make -@ a short for --offroot, but I am not sure how
shell safe @ is, so some other time.

Patches coming up shortly.

Cheers,
Jes
