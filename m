From: Phil Turmel <philip@turmel.org>
Subject: Re: Does a "check" of a RAID6 actually read all disks in a stripe?
Date: Tue, 28 Apr 2020 10:41:29 -0400
Message-ID: <f45df6fc-63eb-a1da-ca0c-5a3db08b454a@turmel.org>
References: <18271293-9866-1381-d73e-e351bf9278fd@fnarfbargle.com>
 <1ccd57ba-9d9a-d10e-4efd-dc0e8a5cf162@fnarfbargle.com>
 <e02412eb-d7f3-cea8-7398-4e5c0d749f43@turmel.org>
 <1d7fe96e-d87a-185d-1599-84cc445383cf@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1d7fe96e-d87a-185d-1599-84cc445383cf@fnarfbargle.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/28/20 10:00 AM, Brad Campbell wrote:
> 
> On 28/4/20 9:47 pm, Phil Turmel wrote:

>> The bad block log misfeature is turned on.  Any blocks recorded in it 
>> will never be read again by MD, last I looked.  This might explain 
>> what you are seeing.
>>
>>
> While I see where you are going, the fact it corrected the bad sector by 
> re-writing it during the re-build would intimate that isn't/wasn't the 
> case.

Ah, yes.  Any chance you have set the sysfs sector limits on a check and 
haven't reset them?

Phil
