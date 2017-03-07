From: Christoph Hellwig <hch@infradead.org>
Subject: Re: When will Linux support M2 on RAID ?
Date: Mon, 6 Mar 2017 20:52:00 -0800
Message-ID: <20170307045200.GA1708@infradead.org>
References: <CAGRSmLsqBF_7eGHdeA=FQbgbjSLMrbRK14mNQxyBcV0PoGYaRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGRSmLsqBF_7eGHdeA=FQbgbjSLMrbRK14mNQxyBcV0PoGYaRQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Mar 05, 2017 at 06:09:42PM -0800, David F. wrote:
> More and more systems are coming with M2 on RAID and Linux doesn't
> work unless you change the system out of RAID mode.  This is becoming
> more and more of a problem.   What is the status of Linux support for
> the new systems?

Your message doesn't make sense at all.  MD works on absolutely any
Linux block device, and I've used it on plenty M.2 form factor devices -
not that the form factor has anything to do with how Linux would treat
a device.
