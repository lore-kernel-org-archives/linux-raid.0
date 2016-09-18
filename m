From: Yi Zhang <yizhan@redhat.com>
Subject: Re: lots of "md: export_rdev(sde)" printed after create IMSM RAID10
 with missing
Date: Sat, 17 Sep 2016 22:53:57 -0400 (EDT)
Message-ID: <1852893042.31197.1474167236990.JavaMail.zimbra@redhat.com>
References: <338941973.7699634.1473230038475.JavaMail.zimbra@redhat.com> <1648084319.7702644.1473230621059.JavaMail.zimbra@redhat.com> <20160908225607.GA66921@kernel.org> <7910bc85-f9c4-1ea3-76a6-40b819738537@intel.com> <wrfjy42u2nvm.fsf@redhat.com> <d4b81424-a77f-5ee9-446c-119657a3fb26@intel.com> <wrfjtwdgqb49.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjtwdgqb49.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Artur
I have test the patch you provided and that works, thanks.

Best Regards,
  Yi Zhang


----- Original Message -----
From: "Jes Sorensen" <Jes.Sorensen@redhat.com>
To: "Artur Paszkiewicz" <artur.paszkiewicz@intel.com>
Cc: "Shaohua Li" <shli@kernel.org>, "Yi Zhang" <yizhan@redhat.com>, linux-raid@vger.kernel.org
Sent: Friday, September 16, 2016 8:31:50 PM
Subject: Re: lots of "md: export_rdev(sde)" printed after create IMSM RAID10 with missing

Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
> On 09/14/2016 11:05 PM, Jes Sorensen wrote:
>> Artur,
>> 
>> You were too fast :) Did you intend to post a patch with a commit
>> message?
>> 
>> Cheers,
>> Jes
>> 
>
> Hi Jes,
>
> I wanted to wait for feedback from Yi first. I just sent a proper patch
> with a commit message.

Thats great, much appreciated!

Jes
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
