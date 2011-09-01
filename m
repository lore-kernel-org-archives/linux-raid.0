From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Raid5 to another raid level??
Date: Thu, 01 Sep 2011 23:34:46 +0100
Message-ID: <4E600886.9080600@anonymous.org.uk>
References: <CAFsPQ_-i_tdPYoT+AF76c7cKNnmt_Ah6KU8EqnYgx3BcyCYNGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFsPQ_-i_tdPYoT+AF76c7cKNnmt_Ah6KU8EqnYgx3BcyCYNGg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Busby <michael.a.busby@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

