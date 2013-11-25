From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: Triple parity and beyond
Date: Sun, 24 Nov 2013 20:48:47 -0800
Message-ID: <l6ukr5$vpa$2@ger.gmane.org>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com> <528AA1EB.3010909@zytor.com> <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com> <528BCA2D.5010500@redhat.com> <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <528D61C5.70902@hardwarefreak.com> <CAJBj3vf7Ot2oUkk6LtkWRouFqrSCKecz0yD4Ds5UGT1BL1ds5A@mail.gmail.com> <528DADB1.8010604@hardwarefreak.com> <CAJBj3vcE07FYi-+xMxwd+u6dVfFU0ryU=j+ekmG8p=cgMhU74g@mail.gmail.com> <528E8FEC.2070204@hardwarefreak.com> <20131123100753.1820ab7c@notabene.brown> <5290252A.8020508@hardwarefreak.com> <20131123160428.6f1c5898@notabene.brown> <CAJBj3vfsbPoke2spzomBQRGqmSG9RCjwfMG1R4mfmJ8SOBZjvw@mail.gmail.com> <5292B030.5030305@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
List-Id: linux-raid.ids

Stan Hoeppner wrote:

<snip<
> "Selection bias" would infer I'm doing some kind of formal analysis,
> which is obviously not the case, though I do understand the point you're
> making.

Nope - the only thing 'selection bias' says is that inferences drawn from a 
non-representative dataset will also be non-representative.

Drawing an inference of 'raid rebuilds are slow' from a mailing list people 
come to when they need to report an issue will overemphasize problems and 
deemphasize cases where everything is working properly.

Also, no matter how quickly a rebuild goes, it's still longer than people 
would like. No matter how quickly it finishes, you're still in a stressed 
state where something has _already_ gone wrong and your parachute is now in 
use and unable to save you a second time.

