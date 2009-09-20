From: Clinton Lee Taylor <clintonlee.taylor@gmail.com>
Subject: Re: [PATCH] barrier support for other md/raid levels
Date: Sun, 20 Sep 2009 23:48:42 +0200
Message-ID: <b7b14cbb0909201448m37947934r2812ef89146b5b01@mail.gmail.com>
References: <19123.9980.940255.937839@notabene.brown>
	 <4AB372BA.6020101@redhat.com>
	 <4D87015385157D4285D56CA6101072FF26C2CCB1@exchange07.valvesoftware.com>
	 <4AB3D148.3060607@redhat.com>
	 <87f94c370909181138g197be2fegd4032778ca6d3351@mail.gmail.com>
	 <4AB3D4C8.1080602@redhat.com>
	 <70ed7c3e0909181318v879ab30h5ffdf8e0b57799b4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909181318v879ab30h5ffdf8e0b57799b4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Greetings ...

2009/9/18 Majed B. <majedb@gmail.com>:
> For what it's worth, I use XFS on one of my arrays, and whenever
> mounting it, I get this error:
>
> [ 2212.567725] Filesystem "dm-0": Disabling barriers, trial barrier write failed
>
> So I guess you could use XFS to run your tests.
 I saw this meesage today, and remember both this thread and that on
my CentOS 5.4, which I have moved a RAID5/ext4 filesystem from a
Fedora 10 ...

 I'm getting these reports in my message log ...

Sep 19 14:59:52 zeus kernel: JBD: barrier-based sync failed on md5 -
disabling barriers
Sep 19 15:06:12 zeus kernel: EXT4-fs: barriers enabled

 Would this help with testing?

>>>>>
>>>>> It seems like what you'd need to robustly test barriers is some sort of
>>>>> barrier-supporting loopback device, which
>>>>> acted correctly with barriers, but had worst-case behavior without them
>>>>> (buffering things for random arbitrarily long periods of time,
>>>>> performing all operations in random order, etc).

 Best of luck ...

Thanks
Mailed
LeeT
