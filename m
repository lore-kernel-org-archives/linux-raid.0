From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Adding more drives/saturating the bandwidth
Date: Tue, 31 Mar 2009 01:23:24 -0700 (PDT)
Message-ID: <439371.59188.qm@web51306.mail.re2.yahoo.com>
References: <87eiwf81e8.fsf@frosties.localdomain>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87eiwf81e8.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com, Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--- On Mon, 30/3/09, Goswin von Brederlow <goswin-v-b@web.de> wrote:

> From: Goswin von Brederlow <goswin-v-b@web.de>
> Subject: Re: Adding more drives/saturating the bandwidth
> To: Jon@eHardcastle.com
> Cc: linux-raid@vger.kernel.org
> Date: Monday, 30 March, 2009, 4:40 PM
> Jon Hardcastle <jd_hardcastle@yahoo.com> writes:
> 
> > Hey guys, How do you know if your machine can handle
> adding some more drives to it? How can you check that there
> is enough BUS IO to handle extra sata cards and also that
> the machine is powerful enough to support say an 8 drive
> raid 5...
> 
> A) Try & error.
> B) look up the speed of the bus and half it. Any bandwidth
> left?
>    make sure the cpu isn't at 100% already as well
> 
> MfG
>         Goswin

Cheers guys, I dont think CPU will be an issue as when i looked yesterday whilst copying to my 6 drive raid 5 array it was at ~10% (the only time i get access issues is when i am smart checking all 6 discs and trying to stream a movie of it at the same time!)

As for try and error... sounds scary as once I have added a drive to the array I can undo the process! I suppose I could add them as JBOD's and then thrash the hell out of them.. whilst accessing the rest of the array... What does halving the bus speed tell me in anycase?


-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'..Be fearful when others are greedy, and be greedy when others are fearful.'
-----------------------
