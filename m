From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RFC: detection of silent corruption via ATA long sector reads
Date: Sun, 04 Jan 2009 21:45:40 -0500
Message-ID: <yq1zli631yj.fsf@sermon.lab.mkp.net>
References: <fa.8mwKV7y4hm+Q6mvIKtp9QGoJYUU@ifi.uio.no>
	<fa.4QcsYZC0gJJwJ0eUOht3hDYaVWs@ifi.uio.no>
	<49580061.9060506@yahoo.com>
	<87f94c370901021226j40176872h9e5723c6da4afcbe@mail.gmail.com>
	<yq13ag174af.fsf@sermon.lab.mkp.net>
	<495F6622.9010103@anonymous.org.uk>
	<yq1eizj5xos.fsf@sermon.lab.mkp.net>
	<4960AC15.8030207@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4960AC15.8030207@anonymous.org.uk> (John Robinson's message of "Sun\, 04 Jan 2009 12\:31\:17 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "John" == John Robinson <john.robinson@anonymous.org.uk> writes:

John> Essentially DIF on 32k blocks instead of 512 byte ones. But
John> perhaps this is a bad assumption and MD/DM already optimises out
John> whole-chunk reads and writes where they're not required (for very
John> short, less-than-one-chunk transactions), and I've no idea whether
John> this happens a lot.

I haven't looked at the RAID4/5/6 code for a long time so I'm not sure
whether they only write dirty pages or the whole chunk + parity ditto.
Neil?

-- 
Martin K. Petersen	Oracle Linux Engineering
