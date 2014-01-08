From: joystick <joystick@shiftmail.org>
Subject: Re: RAID6 reshape integer problem
Date: Wed, 08 Jan 2014 17:32:36 +0100
Message-ID: <52CD7DA4.4080608@shiftmail.org>
References: <loom.20140103T101338-556@post.gmane.org> <52C6B38E.8050804@turmel.org> <CAM8eUy0=YbC68vesaLPSp0RhL_2c8byVyROMGv2DdQ2_JSjYrg@mail.gmail.com> <52C6EE49.2000907@turmel.org> <CAM8eUy180ShDn74JDqqrK8n7tLHqd_VgAaN+3UdqqU50mA+akA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAM8eUy180ShDn74JDqqrK8n7tLHqd_VgAaN+3UdqqU50mA+akA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Piotr Klimek <piotr@klimek.net.pl>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Had I seen this thread earlier... I would probably have responded that 
no, AFAIR it is not safe to reboot while reshaping (!)

In fact i seem to recall that there was a very serious known problem 
during pivot_root , which is at the end of initramfs. A reshape in 
progress through that point would cause data loss. So the array could 
only be assembled after that point, so you had to modify initrd or use a 
livecd so to be sure that it wouldn't find/assemble the array at the 
early stages of boot. This is what I seem to remember.

However by looking for details on such problem everywhere, I am not 
anymore able to find any reference.
Does anybody recall this problem?

Thanks
J.


On 08/01/2014 12:19, Piotr Klimek wrote:
> Hi,
> Everything works fine right now, all I have to do after reboot was
> assemble array using backup file and set MDADM_GROW_ALLOW_OLD=1
> enviroment variable.
>
> Thanks for your help.
>
> 2014/1/3 Phil Turmel <philip@turmel.org>:
>> It is supposed to be safe. With a clean shutdown, the superblock will
>> have a record of the reshape progress and will be able to continue after
>> re-assembly.
>>
>> But you'll probably have to assembly manually to specify the location of
>> the critical section backup file.  If your root FS is in this array,
>> you'll have to intervene in the initramfs.
>>
>> HTH,
>>
>> Phil
>
>

