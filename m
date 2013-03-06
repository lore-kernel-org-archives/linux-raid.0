From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: Kernel 3.7.9 RAID6 hot replace success
Date: Tue, 05 Mar 2013 18:21:27 -0800
Message-ID: <7qli0axdgh.ln2@goaway.wombat.san-francisco.ca.us>
References: <30532376.12.1362508455226.JavaMail.root@zimbra>
 <D7DE2412-0478-4CEC-B771-07E718F011FC@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2013-03-05, Brad Campbell <brad@fnarfbargle.com> wrote:
>
> I do keep a permanent spare drive, but with 3 arrays I manually allocate it in the rare event it is required. This drive had not failed out of the array, so the spare sat idle until I proactively replaced the dodgy drive.--

Are you using the spare-group attribute of arrays in mdadm.conf?  If so,
how well has it worked in your scenario?

--keith

-- 
kkeller@wombat.san-francisco.ca.us


