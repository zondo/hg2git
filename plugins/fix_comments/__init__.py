# Strip trailing periods from commit comments.


def build_filter(args):
    return Filter(args)


class Filter():
    def __init__(self, args):
        pass

    def commit_message_filter(self, commit_data):
        comment = commit_data['desc']
        commit_data['desc'] = comment.rstrip(b'.')
