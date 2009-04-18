From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sat, 18 Apr 2009 10:44:12 +0200
Message-ID: <20090418084412.GB4436@lazy.lzy>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com> <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com> <20090418081239.GB2124@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090418081239.GB2124@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Apr 18, 2009 at 10:12:53AM +0200, Luca Berra wrote:
> uhm, udev should be able to assemble an array without mdadm.conf, not
> that i like it

Actually I was wondering about that, since it
seems not always working.
I tested an array over USB, and the udev thing
sometimes works, sometimes it does not.
But if I stop the remainings of the array and
re-assemble it manually, no problem.
Could it be there is some race condition?

bye,

-- 

piergiorgio
