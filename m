From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sat, 18 Apr 2009 15:52:03 +0200
Message-ID: <20090418135203.GA3448@lazy.lzy>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com> <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com> <20090418081239.GB2124@maude.comedia.it> <F43DC4EB-8E83-4284-A2BE-85EF146AE956@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F43DC4EB-8E83-4284-A2BE-85EF146AE956@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: Luca Berra <bluca@comedia.it>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Apr 18, 2009 at 09:35:33AM -0400, Doug Ledford wrote:
> On Apr 18, 2009, at 4:12 AM, Luca Berra wrote:
>> uhm, udev should be able to assemble an array without mdadm.conf, not
>> that i like it
>
> It does, the question is whether or not it should honor the preferred  
> minor when it assembles an array not in mdadm.conf.

Does it?
Then I should open a bug to Fedora, because to
me it does not (always).

bye,

-- 

piergiorgio
