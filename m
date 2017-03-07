From: Dave Jiang <dave.jiang@intel.com>
Subject: Re: When will Linux support M2 on RAID ?
Date: Tue, 7 Mar 2017 08:46:59 -0700
Message-ID: <9244d1bf-b5c4-f4b0-4d00-cb734d002109@intel.com>
References: <CAGRSmLsqBF_7eGHdeA=FQbgbjSLMrbRK14mNQxyBcV0PoGYaRQ@mail.gmail.com>
 <20170307045200.GA1708@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170307045200.GA1708@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "David F." <df7729@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On 03/06/2017 09:52 PM, Christoph Hellwig wrote:
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

I have a feeling he's talking about this [1] issue.

[1]:
http://www.pcworld.com/article/3123075/linux/linux-wont-install-on-your-laptop-blame-intel-not-microsoft.html
