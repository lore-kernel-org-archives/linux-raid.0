From: "Guy" <bugzilla@watkins-home.com>
Subject: FW: Returned mail: delivery problems encountered
Date: Fri, 12 Nov 2004 18:02:05 -0500
Message-ID: <200411122302.iACN2AN02457@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_00B5_01C4C8E1.BB012DF0"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.

------=_NextPart_000_00B5_01C4C8E1.BB012DF0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

David,
	I think every time I send this to you it bounces.  So, I am sending
it to the list.  Sorry everyone.

Guy

-----Original Message-----
From: Mail Delivery Subsystem [mailto:mailer-daemon@comcast.net] 
Sent: Friday, November 12, 2004 1:47 PM
To: bugzilla@watkins-home.com
Subject: Returned mail: delivery problems encountered

A message (from <bugzilla@watkins-home.com>) was received at 12 Nov 2004
18:47:24 +0000.

The following addresses had delivery problems:

<david@dgreaves.com>
	Permanent Failure:
554_Service_unavailable;_Client_host_[204.127.202.55]_blocked_using_spamsour
ce.ukpost.com;_Site_blacklisted_-_for_more_details_see_http://www.ukpost.com
/spamsource.html
	Delivery last attempted at Fri, 12 Nov 2004 18:47:26 -0000

------=_NextPart_000_00B5_01C4C8E1.BB012DF0
Content-Type: message/delivery-status;
	name="details.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="details.txt"

Reporting-MTA: dns; comcast.net
Arrival-Date: 12 Nov 2004 18:47:24 +0000

Final-Recipient: rfc822; <david@dgreaves.com>
Action: failed
Status: 5.0.0 554_Service_unavailable;_Client_host_[204.127.202.55]_blocked_using_spamsource.ukpost.com;_Site_blacklisted_-_for_more_details_see_http://www.ukpost.com/spamsource.html
Diagnostic-Code: smtp; Permanent Failure: Other undefined Status
Last-Attempt-Date: Fri, 12 Nov 2004 18:47:26 -0000

------=_NextPart_000_00B5_01C4C8E1.BB012DF0
Content-Type: message/rfc822
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment

From: "Guy" <bugzilla@watkins-home.com>
To: "'David Greaves'" <david@dgreaves.com>
Cc: <linux-raid@vger.kernel.org>
Subject: RE: RAID5 - 2nd drive died whilst waiting for RMA
Date: Fri, 12 Nov 2004 13:47:18 -0500
Message-ID: <200411121847.iACIlNN01272@www.watkins-home.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook, Build 11.0.5510
In-Reply-To: <41950143.5000105@dgreaves.com>
Thread-Index: AcTI5bMJlU31vRrxSy+F+zwQTetffQAAdqAA
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2180

Yes a reboot is needed to correct the problem.  Unless you can figure out
how to stop the array.

Guy

-----Original Message-----
From: David Greaves [mailto:david@dgreaves.com] 
Sent: Friday, November 12, 2004 1:30 PM
To: Guy
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA

Guy wrote:

>NO!!!!!
>
>Bad plan, but almost correct.
>If you "--add" a disk, md would think it is a new disk.  And none of the
>existing data would be used.  The array would not start anyway.  But if you
>use the instructions below, you should get your array back to normal.
>  
>
OK, that's encouraging :)

>+ Stop array:
>+ "mdadm /dev/md0 -S"
>  
>
mdadm: fail to stop array /dev/md0: Device or resource busy
Basically they're still mounted and can't unmount 'cos the nfsds are 
running.

Is a reboot the right thing? (back into single user)

David


------=_NextPart_000_00B5_01C4C8E1.BB012DF0--

