From: bobzer <bobzer@gmail.com>
Subject: Re: migrate raid 5 to new server
Date: Fri, 1 Feb 2013 13:41:12 -0500
Message-ID: <CADzS=aruq=m_Zp1=+8h7br-JGtRU-CCkQb_9xGKXo4Joa54orQ@mail.gmail.com>
References: <CADzS=aqSvXZfVDA18u=kV2cTHiWSb6CraFxv+vNO7LzBsfQoPg@mail.gmail.com>
 <CADzS=aqCQdqp66fLKz9Bn=JaYgU8e9QoWXC-WEaMhmRb8=XT4Q@mail.gmail.com>
 <05E9DB5A-FD22-48DB-ABBA-CBBA6EA62562@colorremedies.com> <CADzS=arm1SNze6s8a2aEn0UjXTPNTmAU4ftQ1kpTP13VtbL7sQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzS=arm1SNze6s8a2aEn0UjXTPNTmAU4ftQ1kpTP13VtbL7sQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

ok thank you very much

On Fri, Feb 1, 2013 at 1:37 PM, bobzer <bobzer@gmail.com> wrote:
>
> ok thank you very much
>
>
> On Fri, Feb 1, 2013 at 1:14 PM, Chris Murphy <lists@colorremedies.com>
> wrote:
>>
>>
>> On Jan 31, 2013, at 4:44 PM, bobzer <bobzer@gmail.com> wrote:
>>
>> > Hi,
>> > Anyone can help me ?
>> > Please :-)
>> >
>> > regards
>> > Mathieu
>> >
>> > On Sun, Jan 27, 2013 at 8:32 PM, bobzer <bobzer@gmail.com> wrote:
>> >>
>> >> Hi
>> >> I need to move my raid 5 of 3 disk to a new server
>> >> The question is i have the bad block enabled  and  i'm running the
>> >> devel-3.3 version of mdadm
>> >> Which version of mdadm is the best for me ?
>> >> Do i need to use the same ? Can i upgrade?
>> >>
>> >> Do i have something special to do to migrate?
>>
>> I think this is bleeding edge is why no one has answered. If you're on a
>> dev version of mdadm with a feature not on older versions it seems you must
>> stay with a recent version kernel and mdadm; or you need to build a new
>> array with the versions you're want to use and migrate the data. *shrug*
>>
>> Chris Murphy--
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
