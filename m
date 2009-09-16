From: Chris Webb <chris@arachsys.com>
Subject: Re: LVM and Raid5
Date: Wed, 16 Sep 2009 14:15:36 +0100
Message-ID: <20090916131536.GA3752@arachsys.com>
References: <70ed7c3e0909160320j68c792d2g8ba01ac3c34eaae5@mail.gmail.com>
 <894436.58276.qm@web51307.mail.re2.yahoo.com>
 <70ed7c3e0909160400k578741e7ue687d8fd983d0d12@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70ed7c3e0909160400k578741e7ue687d8fd983d0d12@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Jon@ehardcastle.com, Goswin von Brederlow <goswin-v-b@web.de>, Linux Raid Study <linuxraid.study@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Majed B." <majedb@gmail.com> writes:

> I tested with both dd and hdparm, and in both cases, md0 proved to be
> much faster than the LV itself.

This is quite odd because usually an LVM2 logical volume is just a simple
linear device-mapper target onto the backing device. I could imagine a small
performance change but a large one really surprises me. Could there be
something going on here wrt sync vs non-sync IO?

Best wishes,

Chris.
