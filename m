From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: New setup: partitions or raw devices
Date: Wed, 29 Nov 2017 23:27:53 +0100
Message-ID: <14078b47-29dd-6c07-f680-77ac9445be32@thelounge.net>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
 <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net>
 <CAJH6TXjbAFjP66HN54kiUffd=zt0HUgyQmcvsU-mYpJRUaQafw@mail.gmail.com>
 <e62ea493-3fae-5c3e-5578-f426dc3d254e@thelounge.net>
 <CAJH6TXgtn7Gqryvs1HKfFCodEqXCaHvy+kXX8kRxWgS25ZUDYQ@mail.gmail.com>
 <3654cb70-9d7c-dfc0-f57d-c57004f11f92@thelounge.net>
 <253c22a2-8f77-2737-b3b4-6beef107c28c@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <253c22a2-8f77-2737-b3b4-6beef107c28c@youngman.org.uk>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Wol's lists <antlists@youngman.org.uk>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 29.11.2017 um 23:20 schrieb Wol's lists:
> On 29/11/17 20:02, Reindl Harald wrote:
>> why not RAID5/6? besides 
>> https://www.askdbmgt.com/why-raid5-should-be-avoided-at-all-costs.html 
>> the parity data are additional writes wearing out the drives
> 
> So, if I have a four-drive raid 5, for every 3 blocks of data I write I 
> write 1 parity block. But with raid 1 or 10, for every 3 blocks of data 
> I write, I write *3* "parity" blocks!
> 
> What was that about "the additional writes wearing out the drives" then?
> 
> (Yes, I get the write amplification thing - but if you are writing a lot 
> of data, then raid 5 needs far *fewer* writes.)

RAID10 has a lot of other benefits:

* better performance at all
* lower CPU usage
* only 1 disk is affected with reads at rebuild
* you can clone a whole phyiscal machine easily by just move
   half of the drives to a new machine and start rebuild on
   both - in the past years i cloned multiple machines that
   way which are after that in sync with "synch-machine.sh push/get"

especially the clone thing saves a lot of time when you collected over 
time machines with all sorts of use-cases and storage sizes and you just 
need to consider which one has the most similar setip to the new one

before i drive home from the office "synch-machine.sh push && power off" 
and when i arrive at the office -> CTL+ALT+F" -> Login as root -> 
"synch-machine.sh get", CTRL+ALT+F1 -> grapical login

that way of work is BTW a great backup for human mistakes :-)

