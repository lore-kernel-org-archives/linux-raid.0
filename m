From: William Knop <wknop@andrew.cmu.edu>
Subject: Re: libata badness
Date: Mon, 4 Oct 2004 11:50:13 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60-041.0410041132070.9105@unix43.andrew.cmu.edu>
References: <Pine.LNX.4.60-041.0410040656001.2350@unix48.andrew.cmu.edu>
 <Pine.LNX.4.58.0410040953160.26615@web1.mmaero.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0410040953160.26615@web1.mmaero.com>
To: Jon Lewis <jlewis@lewis.org>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids


> What kind of sata drives?  It's not quite the same end result, but there
> have been several posts on linux-raid about defective Maxtor sata drives
> causing system freezes.  If your drives are Maxtor, download their
> powermax utility and test your drives.  You may find that you have one or
> more marginal drives that appear to work most of the time, but powermax
> will determine are bad.  Replacing one like that fixed my problems.

Ah, well all of them are Maxtor drives... One 6y250m0 and three 7y250m0 
drives. I'm using powermax on them right now. They all passed the quick 
test, and the full test results are forthcoming.

Actually, I was backing up the array (cp from the array - 2 of 3 drives 
running - to a normal drive) when I read your response. Shortly 
thereafter, during the cp (perhaps after copying 100GB-120GB), I got a 
double fault. I've never gotten a double fault before, but I'm guessing 
it's quite a serious error. It totally locked up the machine, and it 
outputted two lines each with a double fault message, followed by a 
register dump.

The saga continues...

Will
