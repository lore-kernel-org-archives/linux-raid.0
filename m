From: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Thu, 27 Apr 2017 21:57:20 +0200
Message-ID: <5c3f7876-1b25-7020-5e7d-01776e7c9903@powerlamerz.org>
References: <20170424110455.GA4949@metamorpher.de>
 <CAHKno4A12N6UGGtJQJRkY0aPbFBBf0Rek91th9Cnx6XWJGouWg@mail.gmail.com>
 <20170424123706.GA6798@metamorpher.de>
 <CAHKno4BR3kdsLU9AnNHvarc-e6UibNr7WQks2ssPX4pE1ZoUpA@mail.gmail.com>
 <20170424133946.GA7057@metamorpher.de>
 <727eeaf5-b856-305d-99b6-e42f3383b699@powerlamerz.org>
 <20170425001614.GA3936@metamorpher.de>
 <CAHKno4A7umuNBUPaHk0vmgj2fnjPgBi2oZJWidhKKaRX7ekgKA@mail.gmail.com>
 <20170425090122.GA4488@metamorpher.de>
 <CAHKno4AuKNxYiMazUy+hRJ2kJCdNNYw5L0uExvWc_52Ocn5V=g@mail.gmail.com>
 <20170425110807.GA5159@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170425110807.GA5159@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 04/25/2017 01:08 PM, Andreas Klauer wrote:
> On Tue, Apr 25, 2017 at 12:40:37PM +0200, Patrik Dahlström wrote:
>> You mentioned something about linear device mapping before. What is
>> that? Is it something I could experiment with? How do I do that?
> 
> https://www.kernel.org/doc/Documentation/device-mapper/linear.txt
> 
> Once you have found where data overlaps on both raids, you create 
> a linear mapping of start..X of the 6disk raid, followed by X..end 
> of the 5disk RAID.
> 
> That way you get a device that holds your data intact as a whole, 
> whereas the raid sets would give you the first half of data on 
> the 6disk raid set (what was already reshaped) and the other half 
> on the 5disk raid set (what had yet to be reshaped).

Success! Using a 126M as data offset gave me valid data for the 5 disk
raid and using linear device mapping I'm able to access my data again.
Some is probably corrupted from my previous destructive recovery
attempts, but it seems like most of the data is still there and
accessible. I will start backup up the most essential data now.

> This is only a way to get read access at the data, making the raid 
> work as a standalone again (resume reshape with lost raid metadata) 
> is another problem, to be tackled after you backed up your data ;)

Now, how do we do this?

// Patrik
