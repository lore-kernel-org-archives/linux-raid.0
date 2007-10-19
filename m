From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 19 Oct 2007 12:35:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710191235041.27246@p34.internal.lan>
References: <18200.49267.763509.924873@stoffel.org>
 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>  <18200.53593.687483.120827@stoffel.org>
 <1192810534.1666.68.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1192810534.1666.68.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 19 Oct 2007, Doug Ledford wrote:

> On Fri, 2007-10-19 at 11:46 -0400, John Stoffel wrote:
>>>>>>> "Justin" == Justin Piszcz <jpiszcz@lucidpixels.com> writes:
>>
>> Justin> On Fri, 19 Oct 2007, John Stoffel wrote:
>>
>>>>
>>>> So,
>>>>
>>>> Is it time to start thinking about deprecating the old 0.9, 1.0 and
>>>> 1.1 formats to just standardize on the 1.2 format?  What are the
>>>> issues surrounding this?
>
> 1.0, 1.1, and 1.2 are the same format, just in different positions on
> the disk.  Of the three, the 1.1 format is the safest to use since it
> won't allow you to accidentally have some sort of metadata between the
> beginning of the disk and the raid superblock (such as an lvm2
> superblock), and hence whenever the raid array isn't up, you won't be
> able to accidentally mount the lvm2 volumes, filesystem, etc.  (In worse
> case situations, I've seen lvm2 find a superblock on one RAID1 array
> member when the RAID1 array was down, the system came up, you used the
> system, the two copies of the raid array were made drastically
> inconsistent, then at the next reboot, the situation that prevented the
> RAID1 from starting was resolved, and it never know it failed to start
> last time, and the two inconsistent members we put back into a clean
> array).  So, deprecating any of these is not really helpful.  And you
> need to keep the old 0.90 format around for back compatibility with
> thousands of existing raid arrays.

Agree, what is the benefit in deprecating them?  Is there that much old 
code or?

>
>>>> It's certainly easy enough to change mdadm to default to the 1.2
>>>> format and to require a --force switch to  allow use of the older
>>>> formats.
>>>>
>>>> I keep seeing that we support these old formats, and it's never been
>>>> clear to me why we have four different ones available?  Why can't we
>>>> start defining the canonical format for Linux RAID metadata?
>>>>
>>>> Thanks,
>>>> John
>>>> john@stoffel.org
>>>> -
>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>
>> Justin> I hope 00.90.03 is not deprecated, LILO cannot boot off of
>> Justin> anything else!
>>
>> Are you sure?  I find that GRUB is much easier to use and setup than
>> LILO these days.  But hey, just dropping down to support 00.09.03 and
>> 1.2 formats would be fine too.  Let's just lessen the confusion if at
>> all possible.
>>
>> John
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -- 
> Doug Ledford <dledford@redhat.com>
>              GPG KeyID: CFBFF194
>              http://people.redhat.com/dledford
>
> Infiniband specific RPMs available at
>              http://people.redhat.com/dledford/Infiniband
>
