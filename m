From: Asdo <asdo@shiftmail.org>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Fri, 09 Dec 2011 17:40:54 +0100
Message-ID: <4EE23A16.6060102@shiftmail.org>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu>
 <20111208075709.587ac227@notabene.brown>
 <654BF752-029F-444F-A4AB-68C3CEA7F8D5@ucsc.edu>
 <20111208091651.2a56dd5b@notabene.brown>
 <2866C99D-B573-4EF3-8FD0-0A40B0C20118@ucsc.edu>
 <20111209065140.107aa286@notabene.brown>
 <46200D05-2D7F-44F8-9323-DCFF720776D2@ucsc.edu>
 <20111209075931.29b26b5e@notabene.brown>
 <D1EB6C45-E127-4EC6-BFDD-BDFCC4607981@ucsc.edu>
 <20111209095033.06136f92@notabene.brown>
 <E88BF285-4224-45F8-952A-0248E7025BDD@ucsc.edu>
 <20111209142006.7ad399f9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20111209142006.7ad399f9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear Neil,
this issue went OK for the OP (and thanks for your continuous support), 
however, exactly this situation is my worst nightmare regarding MD RAID.

It seems to me that MD has no mechanism to safeguard the situation of a 
disconnecting cable (holding multiple drives) and I think this could 
cause major puzzlement of the user potentially followed by major data loss.

I think it should be possible in line of principle to implement a 
mechanism that discriminates between cable disconnects (on multiple 
drives) and a failed single drive:

The technique would be:
BEFORE failing a drive with any symptom that *could* be caused by a 
cable disconnect, (maybe wait a couple of seconds and then) perform a 
read and/or a write (not cached, mandatorily from the platters, and sync 
in case of write) from each of the drives of the array. If multiple 
drives which were believed to be working, do not respond to such 
read/write command, then assume a cable to be disconnected and either 
block the array (is there a blocked state like for other linux 
blockdevices? if not it should be implemented) or set it as read-only. 
Or worst case, disassemble the array. But DO NOT proceed failing the 
drive. OTOH if all other drives respond correctly, assume it's not a 
cable problem and, go ahead failing the drive which was supposed to be 
failed.

The current behaviour is not good because MD will start declaring all 
the failed drives onto the metadatas of the good drives, before 
discovering that there are so many failed drives that the array cannot 
be kept running at all.

So you end up with a down array, but which has also an inconsistent 
state (I think writes could have been performed between the first 
discovered failure and the last discovered failure so the array would 
indeed be inconsistent) and also does not cleanly assemble anymore.

Thank you

