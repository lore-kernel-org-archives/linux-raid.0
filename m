From: Spelic <spelic@shiftmail.org>
Subject: Raid10 algorithm for choosing the reading drive
Date: Tue, 23 Nov 2010 23:47:36 +0100
Message-ID: <4CEC4488.7000703@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello raid ML,
in order to be able to correctly choose the layout for my new raid10 
array, I would like to know one thing:

Every time a (small) read request comes in, MD has to choose one of two 
drives to serve it. It is not clear to me what is the algorithm for 
choosing this. I have looked at the manpages and kernel docs, but they 
do not say.

E.g. I have noticed in n2 (near) mode when one process reads a big file 
sequentially, only half of the drives are used. When a second thread 
reads, the other drives are used. I also noticed this for raid1.
I think this is a good low level technique to avoid starvation between 
two threads and avoid seeks, and with many threads it will still reduce 
starvation by half and reduce seeks.

With the array in offset or far layouts, I notice all drives are used 
for a single reading thread. If another streaming read process comes in, 
will it compete for *all* the drives (and cause massive seeking) or will 
MD assign half of the drives to one process and half to the other process?
(ok maybe for far it's reasonable to assign all drives to all processes, 
but for offset it's not so clear. Also I still haven't really understood 
the algorithm for near, apart from the observation above)

In general, can anybody spend a few words on the algorithm used by MD to 
choose which drive(s) should serve read requests?

Thank you
