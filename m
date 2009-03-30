From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Adding more drives/saturating the bandwidth
Date: Mon, 30 Mar 2009 17:40:31 +0200
Message-ID: <87eiwf81e8.fsf@frosties.localdomain>
References: <440826.81462.qm@web51312.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <440826.81462.qm@web51312.mail.re2.yahoo.com> (Jon Hardcastle's
	message of "Thu, 26 Mar 2009 05:43:45 -0700 (PDT)")
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Hardcastle <jd_hardcastle@yahoo.com> writes:

> Hey guys, How do you know if your machine can handle adding some more drives to it? How can you check that there is enough BUS IO to handle extra sata cards and also that the machine is powerful enough to support say an 8 drive raid 5...

A) Try & error.
B) look up the speed of the bus and half it. Any bandwidth left?
   make sure the cpu isn't at 100% already as well

MfG
        Goswin
