From: Phil Turmel <philip@turmel.org>
Subject: Re: broken raid level 5 array caused by user error
Date: Tue, 19 Jan 2016 12:51:43 -0500
Message-ID: <569E77AF.6040906@turmel.org>
References: <3c05d813e42324cdf95989784f6d7b17@pingofdeath.de>
 <56426499.8000205@turmel.org>
 <ceee2de5aba3ca77efc1146e19896b90@pingofdeath.de>
 <564284F5.9080409@turmel.org>
 <b0cdddd4394bbc1356980bb61ac199c3@pingofdeath.de>
 <56429326.5030405@turmel.org>
 <a7d58e8e4c319c320bc531b8d2bf11e7@pingofdeath.de>
 <44d28ec402622b25c4d4d7a32a8888d9@pingofdeath.de>
 <569D384F.6070208@turmel.org>
 <bb6cce6b0d5bb6c653ef94e4a58388cf@pingofdeath.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080302030603020107030403"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb6cce6b0d5bb6c653ef94e4a58388cf@pingofdeath.de>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias Mueller <raidfail@gmx.de>
Cc: Linux raid <linux-raid@vger.kernel.org>, linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------080302030603020107030403
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi Mathias,

On 01/19/2016 09:35 AM, Mathias Mueller wrote:
> Hi Phil,
> 
> I forgot to add some information: when I was creating the bytestrings
> from my jpg file, I did not start from 0k but from 100k of the jpg file
> (to skip the jpg header).

Ok. But I'm still not confident of chunk boundaries.

>> Very interesting.  You could go one step further and compare the jpeg
>> file contents in the first 1M against the locations found to determine
>> where the chunks actually start and end on each device.  The final
>> offset will be a chunk multiple before these boundaries.  Or do md5 sums
>> of 4k blocks to reduce the amount to inspect.
> 
> How exactly can I do this? Should I create more Bytestrings and do more
> brep with them on my physical devices? I have already results from
> searching bytestrings with an offset of 64k (starting from 100k to 612k
> of my jpeg file, so 9 bytestrings at all). Should I provide a table of
> the results?

Sigh.  I couldn't help myself.  New utility attached.  Curse you Mathias
for an interesting problem! ;-)

Call it with your jpeg and the devices to search, like so:

findHash.py /path/to/picture.jpeg /dev/sd[bcde]

It'll make a map of hashes of each 4k block in the jpeg and then search
the listed devices for those hashes, building a map of the file
fragments.  This will clearly show chunk boundaries.

Please show the output.

Phil

--------------080302030603020107030403
Content-Type: text/x-python;
 name="findHash.py"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="findHash.py"

#! /usr/bin/python2
#
# Locate 4k fragments of a subject file in one or more other files or
# devices.  Only reports two or more consecutive matches.
#
# Usage:
#   findHash.py /path/to/subject/file /dev/sdx|/path/to/image/file [/dev/sdy ...]

import hashlib, sys, datetime

# Read the known file 4k at a time, building a dictionary of
# md5 hashes vs. offset.  Use a large buffer for speed.
# Drops any partial block at the end of the file.
d = {}
pos = long(0)
f = open(sys.argv[1], 'r', 1<<20)
b = f.read(4096)
while len(b)==4096:
	md5 = hashlib.md5()
	md5.update(b)
	h = md5.digest()
	hlist = d.get(h)
	if not hlist:
		hlist = []
		d[h] = hlist
#		print "New hash %s at %8.8x" % (h.encode('hex'), pos)
	hlist.append(pos)
	pos += 4096
	b = f.read(4096)
f.close()

print "%d Unique hashes in %s" % (len(d), sys.argv[1])

def checkAndPrint(match):
	if match[2]>4096:
		print "%20s @ %12.12x:%12.12x ~= %8.8x:%8.8x" % (fname, match[1], match[1]+match[2]-1, match[0], match[0]+match[2]-1)

# Read the candidate files/devices, looking for possible matches.  Match
# entries are vectors of known file offset, candidate file offset, and
# length.
for fname in sys.argv[2:]:
	print "\nSearching for pieces of %s in %s:..." % (sys.argv[1], fname)
	pos = long(0)
	f = open(fname, 'r', 1<<24)
	matches = []
	b = f.read(4096)
	lastts = None
	while len(b)==4096:
		if not (pos & 0x7ffffff):
			ts = datetime.datetime.now()
			if lastts:
				print "@ %12.12x %.1fMB/s   \r" % (pos, 128.0/((ts-lastts).total_seconds())),
			else:
				print "@ %12.12x...\r" % pos,
			sys.stdout.flush()
			lastts = ts
		md5 = hashlib.md5()
		md5.update(b)
		h = md5.digest()
		if h in d:
			i = 0
			while i<len(matches):
				match = matches[i]
				target = match[0]+match[2]
				continuations = [x for x in d[h] if x==target]
				if continuations:
					match[2] += 4096
					i += 1
				else:
					del matches[i]
					checkAndPrint(match)
			if not matches:
				matches = [[x, pos, 4096] for x in d[h]]
		else:
			for match in matches:
				checkAndPrint(match)
			matches = []
		pos += 4096
		b = f.read(4096)
	print "End of %s at %12.12x" % (fname, pos)
	# show matches that continue to the end of the candidate file/device.
	for match in matches:
		checkAndPrint(match)

--------------080302030603020107030403--
