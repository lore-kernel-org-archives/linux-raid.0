From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Kernel 3.7.9 RAID6 hot replace success
Date: Wed, 06 Mar 2013 11:33:16 +0800
Message-ID: <5136B8FC.5010904@fnarfbargle.com>
References: <30532376.12.1362508455226.JavaMail.root@zimbra> <D7DE2412-0478-4CEC-B771-07E718F011FC@fnarfbargle.com> <7qli0axdgh.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7qli0axdgh.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/03/13 10:21, Keith Keller wrote:
> On 2013-03-05, Brad Campbell <brad@fnarfbargle.com> wrote:
>>
>> I do keep a permanent spare drive, but with 3 arrays I manually allocate it in the rare event it is required. This drive had not failed out of the array, so the spare sat idle until I proactively replaced the dodgy drive.--
>
> Are you using the spare-group attribute of arrays in mdadm.conf?

No, have not got that advanced yet. I just keep on top of the monitoring 
e-mails and manage things manually. Thanks for the reminder though. I do 
need to have a look at that a bit closer when I get some more time.

Would not have helped in this application though.

Regards,
Brad
