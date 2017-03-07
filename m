From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: When will Linux support M2 on RAID ?
Date: Tue, 7 Mar 2017 09:50:22 -0500
Message-ID: <a92c6f16-af2d-9d79-fb09-8490aac050db@gmail.com>
References: <CAGRSmLsqBF_7eGHdeA=FQbgbjSLMrbRK14mNQxyBcV0PoGYaRQ@mail.gmail.com>
 <20170307045200.GA1708@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170307045200.GA1708@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "David F." <df7729@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2017-03-06 23:52, Christoph Hellwig wrote:
> On Sun, Mar 05, 2017 at 06:09:42PM -0800, David F. wrote:
>> More and more systems are coming with M2 on RAID and Linux doesn't
>> work unless you change the system out of RAID mode.  This is becoming
>> more and more of a problem.   What is the status of Linux support for
>> the new systems?
>
> Your message doesn't make sense at all.  MD works on absolutely any
> Linux block device, and I've used it on plenty M.2 form factor devices -
> not that the form factor has anything to do with how Linux would treat
> a device.
>
He's referring to the RAID mode most modern Intel chipsets have, which 
(last I checked) Linux does not support completely and many OEM's are 
setting by default on new systems because it apparently provides better 
performance than AHCI even for a single device.  The bigger issue with 
this is that it's damn near impossible to get to the firmware on many 
new systems, and even if you can, some OEM's aren't even giving the 
option to use AHCI mode instead of the RAID mode.

The whole M.2 thing is absolutely bogus though, my thought is that 
people are conflating the two because this switch to using RAID mode by 
default is happening concurrently with a general movement towards using 
M.2 devices as primary storage.
