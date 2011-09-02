From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: freshly grown array shrinks after first reboot - major data loss
Date: Fri, 02 Sep 2011 12:06:06 +0100
Message-ID: <4E60B89E.5020806@anonymous.org.uk>
References: <4E5FA4B5.6010407@macroscoop.nl> <4E5FAEF3.60501@macroscoop.nl> <4E5FB350.3040905@redhat.com> <4E5FC495.7070909@macroscoop.nl> <4E5FCC32.6020402@redhat.com> <4E5FD465.4000809@macroscoop.nl> <4E5FDFF6.4030200@redhat.com> <4E609FAC.6020303@macroscoop.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E609FAC.6020303@macroscoop.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Cc: Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/09/2011 10:19, Pim Zandbergen wrote:
> On 09/01/2011 09:41 PM, Doug Ledford wrote:
>>> I could file a bug on bugzilla.redhat.com if that would help.
>>
>> Feel free, it helps me track things.
>
> https://bugzilla.redhat.com/show_bug.cgi?id=735306

I'm not sure whether it's just the --grow that should complain, or 
perhaps the earlier step of
   mdadm /dev/md/array-using-0.90-metadata --add /dev/3TB
should also complain (even if it'll work with less than 2TiB in use, it 
ought to tell the user they won't be able to grow the array).

Cheers,

John.

