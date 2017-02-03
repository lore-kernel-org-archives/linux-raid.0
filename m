From: Stevie Trujillo <stevie.trujillo@gmail.com>
Subject: mdadm raid6 sequential read slower than reading from userspace
Date: Fri, 3 Feb 2017 23:24:15 +0100
Message-ID: <20170203232415.21c0b16f@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_//1fSxoYsgyDsHCl8ZCp7oa3"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--MP_//1fSxoYsgyDsHCl8ZCp7oa3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello

Kernel:     Linux version 4.9.0-1-amd64 (debian-kernel@lists.debian.org)
            (gcc version 6.3.0 20161229 (Debian 6.3.0-2) ) #1 SMP Debian
            4.9.2-2 (2017-01-12)
CPU:        2xE5-2665
Memory:     256GB
Drives:     6x8TB Seagate
Controller: LSI2008
md0 : active raid6 sdb1[1] sda1[0] sdd1[3] sde1[4] sdc1[2] sdf1[5]
      31255576576 blocks super 1.2 level 6, 512k chunk, algorithm 2
[6/6] [UUUUUU] bitmap: 0/59 pages [0KB], 65536KB chunk

When I read sequentially from one of the disks I get 230-245MB/s. If I
read from all of them at the same time, the performance stays the same
(even if I bind all the dd processes to the same core).
Conclusion: I think the controller is not a bottleneck.

I first tried Debian8 with 3.16 and got 400-500MB/s when dd-ing
from /dev/md0. Upgrading to Debian9 with 4.9.2 roughly doubled my
performance:
53687091200 bytes (54 GB, 50 GiB) copied, 62.0078 s, 866 MB/s
53687091200 bytes (54 GB, 50 GiB) copied, 57.9882 s, 926 MB/s

dd uses 40% cpu and I can't find any process that uses more, so I don't
think I'm limited by CPU.

I wrote a small program that reads directly from the disks and outputs
the same data as reading from md0 would do. It's faster and has
more stable runtime than reading from md0: it finishes in 44.0 +-
0.2seconds (that is ~1150MB/s).

Is it possible to make mdadm work faster? I was hoping it could read
6x240MB/s, but maybe that's not possible. At least I think it should be
able to do 1150MB/s like userspace?
How can I find out what bottleneck? I couldn't see anything obvious
like 100% cpu usage.
I tried copying different tuning instructions I found on Google, but
they usually made negative impact if any.

I attached the program, but I'm still learning programming so it's not
very good.

--
Stevie Trujillo
--MP_//1fSxoYsgyDsHCl8ZCp7oa3
Content-Type: text/x-c++src
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=raid6read.cc

#include <vector>
#include <queue>
#include <thread>
#include <mutex>
#include <condition_variable>
using namespace std;
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <inttypes.h>
#include <sys/poll.h>
#include <scsi/sg.h>
#include <assert.h>
#include <err.h>

#define READ_16 0x88
#define NUM_DISKS 6
#define MAX_READAHEAD 16
#define CHUNK_SIZE (512*1024)

namespace {

struct BufferStorage
{
	int ref_count;
	unsigned char *memory;
};

struct Buffer
{
	BufferStorage *storage;
	unsigned char *buf;
};

struct Request
{
	uint64_t output_idx;
	uint64_t chunk;
};

struct Response
{
	uint64_t output_idx;
	Buffer buffer;
};

struct PendingIO
{
	BufferStorage *storage;
	uint64_t output_idx[4];
};

struct Disk
{
	int sg_fd;
	PendingIO pending_io[MAX_READAHEAD];
	unsigned char slot_i;
	unsigned char slots[MAX_READAHEAD];
	int current_request;
	vector<Request> requests;
};

struct Raid6
{
	Disk disks[6];
};

struct ThreadData
{
	mutex m;
	condition_variable cv;
	uint64_t last_idx;
	vector<Response> responses;
};

static void
sg_read(int sg_fd, void *buf, int pack_id, uint64_t lba, uint64_t len_lba)
{
	uint64_t len_bytes = 512 * len_lba;

	unsigned char cdb[16] = {};
	cdb[0] = READ_16;
	cdb[2] = (lba >> 56) & 0xff;
	cdb[3] = (lba >> 48) & 0xff;
	cdb[4] = (lba >> 40) & 0xff;
	cdb[5] = (lba >> 32) & 0xff;
	cdb[6] = (lba >> 24) & 0xff;
	cdb[7] = (lba >> 16) & 0xff;
	cdb[8] = (lba >> 8) & 0xff;
	cdb[9] = (lba >> 0) & 0xff;
	cdb[10] = (len_lba >> 24) & 0xff;
	cdb[11] = (len_lba >> 16) & 0xff;
	cdb[12] = (len_lba >> 8) & 0xff;
	cdb[13] = (len_lba >> 0) & 0xff;

	sg_io_hdr_t io_hdr;
	memset(&io_hdr, '\0', sizeof(io_hdr));
	io_hdr.interface_id = 'S'; /* SCSI Generic Interface */
	io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
	io_hdr.cmd_len = sizeof(cdb);
	io_hdr.cmdp = cdb;
	io_hdr.dxfer_len = len_bytes;
	io_hdr.dxferp = buf;
	io_hdr.timeout = 20000;
	io_hdr.pack_id = pack_id;

	if (write(sg_fd, &io_hdr, sizeof(io_hdr)) != sizeof(io_hdr))
		err(1, "write");
}

void queue_requests(Disk *disk)
{
	while ((size_t) disk->current_request < disk->requests.size() && disk->slot_i < MAX_READAHEAD) {
		int batch_requests = 1;
		for (; batch_requests < 4 && (size_t) disk->current_request + batch_requests < disk->requests.size(); ++batch_requests) {
			if (disk->requests[disk->current_request].chunk + batch_requests
			 != disk->requests[disk->current_request + batch_requests].chunk
			)
				break;
		}

		unsigned char slot = disk->slots[disk->slot_i++];
		struct PendingIO *pending = &disk->pending_io[slot];
		for (int i = 0; i < 4; ++i)
			pending->output_idx[i] = ~(uint64_t) 0;

		for (int i = 0; i < batch_requests; ++i)
			pending->output_idx[i] = disk->requests[disk->current_request + i].output_idx;

		uint64_t len_bytes = batch_requests * CHUNK_SIZE;
		pending->storage = new BufferStorage;
		pending->storage->ref_count = 0;
		void *buf;
		posix_memalign(&buf, 0x1000, len_bytes);
		pending->storage->memory = (unsigned char *) buf;

		const Request &r = disk->requests[disk->current_request];
		sg_read(disk->sg_fd, pending->storage->memory, slot, r.chunk * CHUNK_SIZE / 512, batch_requests * CHUNK_SIZE / 512);

		disk->current_request += batch_requests;
	}
}

void read_response(vector<Response> &responses, Disk *disk)
{
	sg_io_hdr_t io_hdr;
	memset(&io_hdr, '\0', sizeof(io_hdr));
	io_hdr.interface_id = 'S'; /* SCSI Generic Interface */
	io_hdr.pack_id = -1;

	if (read(disk->sg_fd, &io_hdr, sizeof(io_hdr)) != sizeof(io_hdr))
		err(1, "read");

	assert(io_hdr.pack_id >= 0 && io_hdr.pack_id < MAX_READAHEAD);
	PendingIO *pending = &disk->pending_io[io_hdr.pack_id];

	for (int j = 0; j < 4; ++j) {
		if (pending->output_idx[j] == ~(uint64_t) 0)
			break;

		Buffer buffer;
		buffer.storage = pending->storage;
		buffer.storage->ref_count += 1;
		buffer.buf = buffer.storage->memory + CHUNK_SIZE * j;
		responses.push_back(Response{pending->output_idx[j], buffer});
	}

	disk->slots[--disk->slot_i] = io_hdr.pack_id;
}

/* write the data we read to stdout in correct order */
void writer_function(ThreadData *td)
{
	auto cmp = [](const Response &a, const Response &b) { return a.output_idx > b.output_idx; };
	priority_queue<Response, vector<Response>, decltype(cmp)> responses(cmp);
	uint64_t current_idx = 0;

	while (current_idx < td->last_idx) {
		if (responses.empty() || responses.top().output_idx != current_idx) {
			vector<Response> tmp;
			{
				unique_lock<mutex> lk(td->m);
				td->cv.wait(lk, [=](){ return !td->responses.empty(); });
				tmp = move(td->responses);
			}

			for (const Response &r : tmp)
				responses.push(r);

			continue;
		}

		Response r = responses.top();
		responses.pop();
		unsigned char *buf = r.buffer.buf;
		size_t size = CHUNK_SIZE;

		while (size) {
			ssize_t bytes_written = write(1, buf, size);
			if (bytes_written < 0)
				err(1, "write");

			buf += bytes_written;
			size -= bytes_written;
		}

		if (--r.buffer.storage->ref_count == 0) {
			free(r.buffer.storage->memory);
			delete r.buffer.storage;
		}

		++current_idx;
	}
}

/* run all the disks from the same thread */
void run_sg_poll(Raid6 *raid, ThreadData *writer_td)
{
	for (;;) {
		struct pollfd pfds[NUM_DISKS];
		int nfds = 0;

		for (int i = 0; i < NUM_DISKS; ++i) {
			Disk *disk = &raid->disks[i];
			if (disk->sg_fd < 0)
				continue;

			queue_requests(disk);
			if ((size_t) disk->current_request == disk->requests.size() && disk->slot_i == 0) {
				close(disk->sg_fd);
				disk->sg_fd = -1;
				continue;
			}

			pfds[nfds++] = (struct pollfd) { raid->disks[i].sg_fd, POLLIN, 0 };
		}

		if (!nfds)
			break;

		int ret = poll(pfds, nfds, -1);
		if (ret <= 0)
			err(1, "poll");

		vector<Response> responses;
		for (int i = 0; i < NUM_DISKS; ++i) {
			Disk *disk = &raid->disks[i];
			if (disk->sg_fd >= 0)
				read_response(responses, disk);
		}

		{
			unique_lock<mutex> lk(writer_td->m);
			writer_td->responses.insert(writer_td->responses.end(), responses.begin(), responses.end());
		}
		writer_td->cv.notify_one();
	}
}

/* run each disk from one thread */
void run_sg_single(Raid6 *raid, Disk *disk, ThreadData *writer_td)
{
	for (;;) {
		queue_requests(disk);
		if ((size_t) disk->current_request == disk->requests.size() && disk->slot_i == 0) {
			close(disk->sg_fd);
			disk->sg_fd = -1;
			break;
		}

		vector<Response> responses;
		read_response(responses, disk);

		{
			unique_lock<mutex> lk(writer_td->m);
			writer_td->responses.insert(writer_td->responses.end(), responses.begin(), responses.end());
		}
		writer_td->cv.notify_one();
	}
}

}

int main(int argc, char **argv)
{
	if (argc != 1 + NUM_DISKS)
		errx(1, "usage: disks");

	Raid6 raid;

	for (int i = 0; i < NUM_DISKS; ++i) {
		const char *path = argv[1 + i];
		Disk *disk = &raid.disks[i];

		disk->sg_fd = open(path, O_RDWR);
		if (disk->sg_fd < 0)
			err(1, "open(%s)", path);

		disk->current_request = 0;
		disk->slot_i = 0;
		for (int i = 0; i < MAX_READAHEAD; ++i)
			disk->slots[i] = i;
	}

	uint64_t num_chunks = 102400; // 50TB

	/* precompute all the chunks we want the disks to read */
	uint64_t output_idx = 0;
	for (uint64_t chunk = 0; chunk < num_chunks; ++chunk) {
		uint64_t data_offset = 2048 * 512 / (512*1024) /* from partitioning */
		                     + 256*1024*512 / (512*1024); /* from mdadm --examine */
		/*
		 * stripe0: bcde|fa
		 * stripe1: abcd|ef
		 * stripe2: fabc|de
		 */
		int64_t stripe = chunk / 4;
		uint64_t slot = chunk % 4;
		int64_t disk_idx = 1 - stripe + slot;
		disk_idx %= 6;
		disk_idx = disk_idx + (disk_idx >> 63 & 6);
		raid.disks[disk_idx].requests.push_back(Request{output_idx++, data_offset + stripe});
	}

	ThreadData writer_td;
	writer_td.last_idx = output_idx;

	thread writer_thread(writer_function, &writer_td);

	if (0) {
		run_sg_poll(&raid, &writer_td);
	} else {
		thread threads[6];

		for (int i = 0; i < NUM_DISKS; ++i)
			threads[i] = move(thread(run_sg_single, &raid, &raid.disks[i], &writer_td));

		for (int i = 0; i < NUM_DISKS; ++i)
			threads[i].join();
	}

	writer_thread.join();
	return 0;
}

--MP_//1fSxoYsgyDsHCl8ZCp7oa3--
