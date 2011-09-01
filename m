From: Doug Ledford <dledford@redhat.com>
Subject: Re: freshly grown array shrinks after first reboot - major data loss
Date: Thu, 01 Sep 2011 15:41:42 -0400
Message-ID: <4E5FDFF6.4030200@redhat.com>
References: <4E5FA4B5.6010407@macroscoop.nl> <4E5FAEF3.60501@macroscoop.nl> <4E5FB350.3040905@redhat.com> <4E5FC495.7070909@macroscoop.nl> <4E5FCC32.6020402@redhat.com> <4E5FD465.4000809@macroscoop.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5FD465.4000809@macroscoop.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/01/2011 02:52 PM, Pim Zandbergen wrote:
> On 09/01/2011 08:17 PM, Doug Ledford wrote:
>> the bug that needs fixed is that mdadm should have refused to grow a
>> 0.90 superblock based array beyond the 2TB limit
> Yes, that's exactly what I am aiming for.
>
> I could file a bug on bugzilla.redhat.com if that would help.

Feel free, it helps me track things.

> I'm not sure whether I need to keep my hosed array around
> in order to be able to reproduce things.

I don't think that's necessary at this point.  It seems pretty obvious 
what's going on and should be easy to reproduce.

