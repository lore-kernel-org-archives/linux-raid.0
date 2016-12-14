From: "Juan Carlos Carvajal B." <juca@juan-carlos.info>
Subject: Re: What is the solution for USB HDs
Date: Wed, 14 Dec 2016 12:08:47 +0100
Message-ID: <CAMQE2N47aUPkW4s8juNWLm7TmRhkk6B4UOo9TbGm1ZoujgokCQ@mail.gmail.com>
References: <13e51316a11df7b0c9f5ab89392361de@juan-carlos.info>
 <171542c9-1ab8-0993-733d-fbb95467f512@websitemanagers.com.au> <9481982b-bfda-644e-e160-74b94bbbec0c@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9481982b-bfda-644e-e160-74b94bbbec0c@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,

usbcore.autosuspend=3D-1

This might be the solution! I'll test it and let you know.

And regarding power issues:

- this was the first thing I notices and I bought a powered usb-hub to
provide enough current to the HDs.

Using USB drives is kind of a home user scenario. I understand that
MDADM might be more focused on large data centers, but would be great
to have such a great tool also available for the average joe.

Best!
Juan Carlos Carvajal Berm=C3=BAdez
+43 650 477 0005
juca@juan-carlos.info
Beingasse 17/2/3
AT 1150, Wien
www.juan-carlos.info


On 12 December 2016 at 04:17, Phil Turmel <philip@turmel.org> wrote:
> On 12/11/2016 05:14 PM, Adam Goryachev wrote:
>> On 12/12/16 04:14, juca@juan-carlos.info wrote:
>> If you are still having problems after that, then please try to post
>> more details on what happens when the drives vanish (eg, kernel logs,
>> system logs, etc).
>>
>> Also, you might consider an alternative SBC, some have SATA ports
>> already available (RPi are the only SBC's I've used, but there are many
>> other options/variations).
>
> There's also a kernel boot parameter that can cut off all USB
> auto-suspend, which I suspect is part of the problem.  It has been known
> for a long time that USB is not robust enough to be trusted in MD arrays.
>
> { looking around..... }
>
> usbcore.autosuspend=3D-1
>
> is what you need in your bootloader or builtin to the kernel.
>
> Phil
