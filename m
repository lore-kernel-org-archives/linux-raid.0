From: Michael Busby <michael.a.busby@gmail.com>
Subject: Re: Raid5 to another raid level??
Date: Thu, 1 Sep 2011 16:50:44 -0700
Message-ID: <-7094796685559591664@unknownmsgid>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: john.robinson@anonymous.org.uk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Will test tomorrow once back in the office, hope the 4tb sync will be
finished by then

I will report back my findings



-- Sent from my HP TouchPadOn 1 Sep 2011 11:34 PM,
<john.robinson@anonymous.org.uk> wrote:
On 01/09/2011 22:50, Michael Busby wrote:
> I have found the following and see that you can convert from raid4 to
> raid0 fairly easy
>
>
> http://ubuntuforums.org/showpost.php?p=10412231&postcount=20
>
> i have a 2 disk raid5 and want to be able to convert this to raid0, i
> was thinking of adding a extra 2 disk and setting them up as raid0,
> moving the data over then adding the original raid5 disks to the raid0
> setup, but i see that you are unable to add disk to a raid0 setup,
> would it be possible to setup a raid4 with 2 disks and 1 missing, move
> the data from the raid5 to raid4 then add both of the original disks
> to the raid4 the downgrade this to raid0???

Off the top of my head, feeling slightly sozzled (been for a few beers),
this might work, but as your linked post referring to a list reply from
Neil Brown says, you should test first. You could use some USB sticks,
or alternatively loopback devices are ideal for this kind of test.

Cheers,

John.
