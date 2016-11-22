From: Phil Turmel <philip@turmel.org>
Subject: Re: Please help RAID1 complete fail no superblock
Date: Tue, 22 Nov 2016 17:01:07 -0500
Message-ID: <d1b93e98-5d6a-01e4-5272-e3cd61e9136d@turmel.org>
References: <869594.583611132-sendEmail@optimum>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <869594.583611132-sendEmail@optimum>
Sender: linux-raid-owner@vger.kernel.org
To: "theelectricengineer@gmail.com" <theelectricengineer@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "antlists@youngman.org.uk" <antlists@youngman.org.uk>, "george.rapp@gmail.com" <george.rapp@gmail.com>
List-Id: linux-raid.ids

Hi Yaniv,

On 11/22/2016 03:38 PM, theelectricengineer@gmail.com wrote:

> Thank you for informing me about the conventions,
> I'll try to conform to all of them.
> (what does trim quotes mean?)

Trim quotes means to delete repetitive material in the quotation of the
previous mail, leaving just the part(s) you are responding to.
Especially remove signature blocks and large blocks of data.  The list
archives will have the original mails for anyone interested later.

> I tried sending these emails through gmail and Thunderbird
> but kept getting an automatic reply saying that the emails were blocked,
> so I'm sending this via the command line (linux terminal).
> I don't know how to avoid breaking the thread this way.

I received all of them (-:  You need to turn off "html" output --
kernel.org rejects HTML email, even if there's a plain-text alternate in
the mail.  In thunderbird, go to "Preferences", "Composition",
"General", "Send Options..." and then set the check box for sending in
plain text.

Avoid sending from Gmail -- it's possible but there are quirks.

> I ran both gdisk and parted, here is the output:
> 
> gdisk -l /dev/sdb
> GPT fdisk (gdisk) version 0.8.5

> Number  Start (sector)    End (sector)  Size       Code  Name
>    1            2048      5860532223   2.7 TiB     0700 

This is good.

> gdisk -l /dev/sdc
> GPT fdisk (gdisk) version 0.8.5

> Number  Start (sector)    End (sector)  Size       Code  Name

This is bad.

> (there are no values for sdc in both gdisk and parted, looks bad)

Yup.  Please provide the output of these two commands in separate
replies (they'll be too big for one reply):

dd if=/dev/sdb1 bs=4k count=4k |hexdump -C |head -n1000

dd if=/dev/sdc bs=4k count=4k |hexdump -C |head -n1000

> I greatly appreciate your help.
> 
> Thank you,

You're welcome.  And don't panic.

Phil

