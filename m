From: John McMonagle <johnm@advocap.org>
Subject: Convert raid5 to raid1?
Date: Thu, 10 Mar 2005 15:38:30 -0600
Message-ID: <4230BE56.6090905@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Was planning to adding a hot spare to my 3 disk raid5 array and was 
thinking if I go to 4 drives I would be a  better off  as 2 raid1 arrays 
considering the current state of raid5.

If you think that is wrong please speak up now :)

Thinking I would  make a raid1  array for /.
The rest of the first pair  and the second pair of disks raid1 and tie 
together with lvm2.

Can easily fit what I have so far on 1 drive so figure I could build the 
first 2 raids on it  them copy from the current degraded array.

Just wonder what happens to the md sequence when I remove the original 
raid arrays?
When I'm done will I have md0,md1 and md2 or  md2,md3 and md4?

John


