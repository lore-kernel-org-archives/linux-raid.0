From: Drew <drew.kay@gmail.com>
Subject: Re: mdadm: sending ioctl [1261|800c0910] to a partition!
Date: Mon, 11 Nov 2013 05:32:09 -0800
Message-ID: <CACJz6QsCxgk981szeA-ptZFy5fGE7W+FzrzoATD9YqxhhZv_LQ@mail.gmail.com>
References: <FE57A73F-D70A-4D2C-A658-BB320A0ECA35@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FE57A73F-D70A-4D2C-A658-BB320A0ECA35@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Apparently harmless.

https://bugzilla.redhat.com/show_bug.cgi?id=783955

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=656899:

Sounds like it's a warning for developers as part of a trace of SCSI
ioctls. Look like it was patched in newer kernels.

-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
