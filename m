From: peter davidson <merrymeetpete@hotmail.com>
Subject: Re: Nvidia Raid5 Failure
Date: Sun, 13 Apr 2014 11:59:04 +0100
Message-ID: <DUB122-W49942A16FCC72C926DDCB9A3560@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi David,

=46or some reason this never made it through to my email inbox - I hop =
I haven't messed up the format as I have pulled the text in from a brow=
ser. Thanks (belatedly) for your response. I put some comments below.
=A0
>> Hi Folks,
>>
>> My computer suddenly shut down due to a failed memory module -
>> damaging the 1.8TB RAID5 array of three disks.
>>
>> The computer was able to boot with a degraded array (Windows 7 OS wa=
s
>> on the array) but I was unable to get the array to rebuild using the
>> Nvidia toolset - either at BIOS level or in Windows 7. Now the
>> computer will not boot from the array.
>>
>> I had something very similar to this happen a few weeks ago when the
>> mother board failed - I was able to limp things along to get a backu=
p
>> of all important data.
>>
>> I am interested to know if LINUX will be able to recover the array
>> for me this time. Having got part way through this process before on
>> the previous failure (which led me to this forum), I am keen to
>> follow this through as an exercise knowing I have a backup of the
>> really important stuff.
>>
>> I intend to build LINUX onto a new disk and work through this in the
>> coming days - what would be my best choice of distro for this
>> exercise? I am hoping to find something that has all the relevant
>> tools and is relatively simple to get up and running with a friendly
>> GUI to help me navigate round.
>>
>> I used to work on various databases running on UNIX servers so I hop=
e
>> I can still can find my way round a terminal window.
>>
>> Thanks in advance for any support anyone can offer me!
>>
>> Regards,
>>

>As a general point, don't do /anything/ to write to the disks or attem=
pt
>to recover or rebuild them until you have copied off /all/ important
>data to safe backups.  If you have booted Windows from the array, then
>step one is to shut it down and do not even consider booting it until
>backups are all in place and double-checked.

On this note I was able to get the all useful data out to a couple of o=
ld disks. I have decided to hold off trying to reconstruct the array no=
w until I get a second copy of the useful stuff on a new disk that I ha=
ve ordered. Once everything is back together this new disk will be for =
my backup images to land on - strangely this whole thing started on the=
 weekend I decided to get a proper backup of my data - what a coinciden=
ce!=20

>
>You want to use a live CD for recovery here - it will let you play
>around with the disks without risking causing more damage.  My usual
>choice of Linux live CD for recovery purposes is System Rescue CD - I
>can't tell you if it is the best choice here, and I haven't needed to
>recover raid arrays using it.  But I find it very useful for testing a=
nd
>configuration, and have used it to recover data or fix up broken Windo=
ws
>systems.

I tried the Fedora live CD at first - this has dsadm but there was some=
thing missing (dm-raid45 module) that meant I could not use the command=
 with my particular flavour of NVIDIA fake raid, the CD also didn't hav=
e mdraid. I then went on to download the Ubuntu live disk which had a c=
rack at starting the array but didn't manage it - I really didn't like =
that it tried to load up the array without my being able to do anything=
 about it - it also marked the array degraded and finally failed on a s=
econd start up that caused a kernel panic. I thought the idea of a Live=
 CD was that it should be passive in terms of fiddling round with your =
existing disks and data at start up.

In my original question I was searching for a suitable LINUX install or=
 live CD that would have everything on it I might need to get to work o=
n the array. I went with the XUbuntu full installation on a seperate di=
sk. It also didn't have mdadm but the OS was polite enough to tell me t=
he exact command to issue to get it installed. This route therefore dep=
ends on an internet connection which proved tricky as the wireless adap=
ter does not seam usable in any 64 bit OS. I got there in the end - goo=
d old fashioned network cables are very reliable!

>
>Another option you should consider is a Windows live CD.  You can't
>legally download and burn one, AFAIK, but there are plenty available i=
f
>you are happy to look about.  There are also several Windows live CD
>generators that will make a bootable Windows CD from another windows
>machine, and can include utility programs.  They are particularly
>popular for malware recovery, but I expect you can put your Nvidia rai=
d
>software on them.

None of the windows OSs can do anything to put the array together witho=
ut the Nvidia support packages. Unfortunately now the Nvidia software w=
on't rebuild the degraded array. The Nvidia tools provide no feedback o=
n what is going on - you either succeed or fail in what you are trying =
to do - no tweaking allowed. So thats why LINUX looks a good option for=
 this exercise.

>As for how well you can access the data and/or recover and/or rebuild
>your array from Linux, it all depends on the support for your Nvidia
>raid.  Someone here might have experience and can give you information=
,
>but your best starting point would be Nvidia's website.

Nvidia document their Windows GUI tools and give a few words on their B=
IOS utility - neither of these tools are able to put things straight fr=
om where things lie at the moment.

> There are Linux
>drivers and utilities for most proper hardware raid systems, but if th=
is
>is a Nvidia-specific fake raid, it might not be supported.  Fake raid =
is
>not very popular in the Linux world - it combines the disadvantages of
>software raid with the disadvantages of hardware raid, and the benefit=
s
>of neither.  It's only real advantage is if you want to use Windows wi=
th
>raid and don't want to pay for proper hardware raid.  Intel's "matrix"
>is far and away the most popular fake raid, and has good support in
>Linux, but I cannot say about Nvidia's raid.

I have read elsewhere that mdadm>=3D3 will cope with NVRAID - the fact =
that the Ubuntu Live CD had a good go at starting the array with madadm=
 makes me think it is worth pursuing LINUX.

>
>
>If you want to set up a new system with Linux raid, then you will be
>able to get pointers and help in this list - but it's not really
>suitable for "how to get started with Linux" information.

I saw the further mails with Scot on this - I thought it would be on to=
pic to ask for a Linux distro that would have everything I needed in pl=
ace to get working with the array - as you can see from above I have be=
en fumbling round with a few versions of LINUX and am dismayed at the s=
heer number available. Apologies if I led the forum away from its inten=
ded purpose.

> And if you
>want to mix Windows and Linux on the same system, be aware that Window=
s
>can't work with Linux software raid, and can't understand Linux
>filesystems (at least, not easily).  It is often much easier to keep
>them on separate machines and sharing files over the network.
>Alternatively, consider using VirtualBox to let you run one system as =
a
>virtual machine inside the other.

I like the idea of a NAS (or even an old machine on the network) runnin=
g LINUX with the RAID on it. I have seen enough of nvraid fake raiding =
to say I want to get off there asap - or at the very least have a full =
backup and recovery procedure with redundancy in place to continue with=
 it any further.=20

>
>mvh.,
>
>David
>--
>To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
>the body of a message to majordomo@xxxxxxxxxxxxxxx
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
