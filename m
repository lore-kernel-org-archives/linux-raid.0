From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: unknown partition table starting with 2.6.28
Date: Sat, 16 Jan 2010 12:43:22 +0000
Message-ID: <4B51B46A.4080302@anonymous.org.uk>
References: <4B51010E.9090800@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B51010E.9090800@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/01/2010 23:58, Timothy D. Lenz wrote:
> I am trying to update my kernel from 2.6.26.8 to the current .32. 
[...]
> Starting with .28 I am getting an error about unknown partition table 
> for all 3 md's. md0 is boot and main programs, md1 is swap, md2 is 
> mostly recordings storage for vdr. All 3 are raid 1 and raid is built in.

Your md devices aren't partitioned so you can quite safely ignore the 
warning. See also http://marc.info/?l=linux-raid&m=125797242110594&w=2

Cheers,

John.

